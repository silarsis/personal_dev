#!/bin/bash
#
# Script to install any left-overs

DEBIAN_FRONTEND=noninteractive

# Add the lxc-docker package and other requirements
wget -q -O - https://get.docker.io/gpg | apt-key add -
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
apt-get update -qq && apt-get -yq upgrade
apt-get install -yq lxc-docker git ruby1.9.3 openvswitch-switch python-pip python-dev dnsmasq

# Add user to the docker group, so we don't have to sudo everything.
[ $(id -u vagrant >/dev/null 2>&1) ] && gpasswd -a vagrant docker
[ $(id -u ubuntu >/dev/null 2>&1) ] && gpasswd -a ubuntu docker

# Install docker-api for our provisioning script
gem install docker-api

# Link our script into the path - set your env variable if you want a default config file
ln -s /vagrant/docker/drun.sh /usr/local/bin/drun

DOCKERIP=`/sbin/ifconfig docker0 | grep 'inet addr' | awk 'BEGIN { FS = "[ :]+" } ; { print $4 }'`

# Overwrite the dnsmasq configuration
cat << EOF > /etc/dnsmasq.conf
domain-needed
local=/dev/
listen-address=${DOCKERIP}
EOF
service dnsmasq restart
sed -i 's/nameserver 127.0.0.1/nameserver ${DOCKERIP}/' /etc/resolv.conf

# Install storm, for ssh key management
pip install stormssh

# Run the registry - background this because it takes a while
/vagrant/docker/drun.sh -r registry