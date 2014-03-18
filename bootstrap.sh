#!/bin/bash
#
# Script to install any left-overs

DEBIAN_FRONTEND=noninteractive

# Add the lxc-docker package and other requirements
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
echo "deb http://pkg.jenkins-ci.org/debian binary/" > /etc/apt/sources.list.d/jenkins.list
wget -q -O - https://get.docker.io/gpg | apt-key add -
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
apt-get update -qq && apt-get -yq upgrade
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

# Install docker-api for our provisioning script
gem install docker-api

# Fix the docker conf to listen on the static interface
# This is useful for letting other containers talk to our docker,
# which I was intending for running DinD
sed -i 's!DOCKER_OPTS=!DOCKER_OPTS="-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock"!' /etc/init/docker.conf
service restart docker

# Link our script into the path - set your env variable if you want a default config file
ln -s /vagrant/docker/drun.sh /usr/local/bin/drun

DOCKERIP=`/sbin/ifconfig docker0 | grep 'inet addr' | awk 'BEGIN { FS = "[ :]+" } ; { print $4 }'`

# Overwrite the dnsmasq configuration
# DNSMasq is setup as a primitive service discovery,
# but not currently (20140306) hooked in.
cat << EOF > /etc/dnsmasq.conf
domain-needed
local=/dev/
listen-address=${DOCKERIP}
EOF
service dnsmasq restart
sed -i 's/nameserver 127.0.0.1/nameserver ${DOCKERIP}/' /etc/resolv.conf

# Install storm, for ssh key management
pip install stormssh

# Run the registry
/vagrant/docker/drun.sh registry

# ngrok, because it's useful
wget -q -O - https://dl.ngrok.com/linux_386/ngrok.zip | funzip > /usr/local/bin/ngrok && chmod 755 /usr/local/bin/ngrok