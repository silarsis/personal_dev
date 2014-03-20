#!/bin/bash
#
# Script to install any left-overs

DEBIAN_FRONTEND=noninteractive

# Add the lxc-docker package and other requirements
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list
wget -q -O - https://get.docker.io/gpg | apt-key add -
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
apt-get update -qq
apt-get install -yq apt-cacher-ng
apt-get -yq upgrade
# Docker tools
apt-get install -yq lxc-docker cgroup-lite
# Python to support storm, a ssh key manager
apt-get install -yq python-pip python-dev
# Things I always want
apt-get install -yq git less vim wget socat tcpdump netcat unzip

# Add user to the docker group, so we don't have to sudo everything.
# On a local vbox it's vagrant, on AWS it's ubuntu
[ $(id -u vagrant >/dev/null 2>&1) ] && gpasswd -a vagrant docker
[ $(id -u ubuntu >/dev/null 2>&1) ] && gpasswd -a ubuntu docker

# Install storm, for ssh key management
pip install stormssh

# Install docker-api for our provisioning script
apt-get install -yq ruby-dev
gem install docker-api

# Link our script into the path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[ ! -e /usr/local/bin/drun ] && ln -s ${DIR}/docker/drun.sh /usr/local/bin/drun

# Fix the docker conf to listen on the static interface and use skydock
cat << EOF > /etc/default/docker
# Docker Upstart and SysVinit configuration file

# Customize location of Docker binary (especially for development testing).
#DOCKER="/usr/local/bin/docker"

# Use DOCKER_OPTS to modify the daemon startup options.
#DOCKER_OPTS="-dns 8.8.8.8 -dns 8.8.4.4"

# If you need Docker to use an HTTP proxy, it can also be specified here.
#export http_proxy="http://127.0.0.1:3128/"

# This is also a handy place to tweak where Docker's temporary files go.
#export TMPDIR="/mnt/bigdrive/docker-tmp"
NS=\$(grep nameserver /etc/resolv.conf | cut -d' ' -f2)
DOCKER_OPTS="-r=true -H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock --dns 127.0.0.1 --dns \${NS}"
EOF
service docker restart && sleep 1

# Run a cache - mkdir in case we're running on non-vbox and not mapped through
mkdir -p /var/cache/angry-caching-proxy
/usr/local/bin/drun angry-caching-proxy

# Run Skydock
DOCKERIP=$(/sbin/ifconfig docker0 | grep 'inet addr' | awk 'BEGIN { FS = "[ :]+" } ; { print $4 }')
NS=$(grep nameserver /etc/resolv.conf | cut -d' ' -f2)
docker pull crosbymichael/skydns
docker run -d -p ${DOCKERIP}:53:53/udp --name skydns crosbymichael/skydns --nameserver ${NS}:53 -domain docker
docker pull crosbymichael/skydock
docker run -d -v /var/run/docker.sock:/docker.sock --name skydock --link skydns:skydns crosbymichael/skydock --ttl 30 --environment dev -s /docker.sock --domain docker

# Run the registry
/usr/local/bin/drun registry

# ngrok, because it's useful
if [ ! -e /usr/local/bin/ngrok ]; then
  wget -q -O - https://dl.ngrok.com/linux_386/ngrok.zip | funzip > /usr/local/bin/ngrok && chmod 755 /usr/local/bin/ngrok
fi

# Useful aliases
cat << EOF > /etc/profile.d/docker.sh
docker_run_shell () {
  docker run -i -t $1 /bin/bash
}
alias dsh=docker_run_shell
EOF
chmod +x /etc/profile.d/docker.sh
