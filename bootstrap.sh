#!/bin/bash
#
# Script to install any left-overs

DEBIAN_FRONTEND=noninteractive

# Disable IPv6
echo net.ipv6.conf.all.disable_ipv6=1 > /etc/sysctl.d/disableipv6.conf
sed -i '/::/s/^/#/' /etc/hosts
sed -i '/ipv6=yes/s/yes/no/' /etc/avahi/avahi-daemon.conf

# Make DNS sane
if [ ! $(grep single-request-reopen /etc/resolv.conf) ]; then
  echo 'options single-request-reopen' > /etc/resolvconf/resolv.conf.d/tail
  service networking restart
fi

# Add the lxc-docker package and other requirements
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
wget -q -O - https://get.docker.io/gpg | apt-key add -
apt-get update -yqq && apt-get -yq upgrade
# Docker tools
apt-get install -yq lxc-docker cgroup-lite
# Python to support storm, a ssh key manager
apt-get install -yq python-pip python-dev
# Things I always want
apt-get install -yq git less vim wget socat tcpdump netcat unzip telnet

# Add user to the docker group, so we don't have to sudo everything.
# On a local vbox it's vagrant, on AWS it's ubuntu
[ $(id -u vagrant >/dev/null 2>&1) ] && gpasswd -a vagrant docker
[ $(id -u ubuntu >/dev/null 2>&1) ] && gpasswd -a ubuntu docker

# Install storm, for ssh key management
pip install stormssh

# Install fig, latest version to get 'privileged' support
mkdir -p /tmp/git && pushd /tmp/git && git clone https://github.com/orchardup/fig.git && cd fig && python setup.py install && rm -rf /tmp/git && popd
#pip install fig

# Install docker-api for our provisioning script
apt-get install -yq ruby-dev
gem install bundler
gem install docker-api

# Link our script into the path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
[ ! -e /usr/local/bin/drun ] && ln -s ${DIR}/docker/drun.sh /usr/local/bin/drun

# Fix the docker conf to listen on the static interface
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
DOCKER_OPTS="-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock"
EOF
service docker restart && sleep 1

# Run a cache - mkdir in case we're running on non-vbox and not mapped through
ln -s /var/spool/squid3 /tmp/squid3 # This should be a param to run.sh
#mkdir -p /vagrant/proxy && cd /vagrant/proxy && wget https://github.com/silarsis/docker-proxy/archive/master.zip && unzip master.zip && cd docker-proxy-master && ./run.sh

# Run the registry
#/usr/local/bin/drun registry

# ngrok, because it's useful
if [ ! -e /usr/local/bin/ngrok ]; then
  wget -q -O - https://dl.ngrok.com/linux_386/ngrok.zip | funzip > /usr/local/bin/ngrok && chmod 755 /usr/local/bin/ngrok
fi

# Useful aliases
cat << EOF > /etc/profile.d/docker.sh
docker_run_shell () {
  docker run -i -t \$1 /bin/bash
}
alias dsh=docker_run_shell
EOF
chmod +x /etc/profile.d/docker.sh
