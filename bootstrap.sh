#!/bin/bash
#
# Script to install any left-overs

DEBIAN_FRONTEND=noninteractive

# Add the lxc-docker package and other requirements
wget -q -O - https://get.docker.io/gpg | apt-key add -
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
apt-get update -qq
apt-get install -q -y --force-yes lxc-docker git ruby1.9.3 openvswitch-switch python-pip python-dev

# Add user to the docker group, so we don't have to sudo everything.
[ $(id -u vagrant >/dev/null 2>&1) ] && gpasswd -a vagrant docker
[ $(id -u ubuntu >/dev/null 2>&1) ] && gpasswd -a ubuntu docker

# Install docker-api for our provisioning script
gem install docker-api

# Link our script into the path - set your env variable if you want a default config file
ln -s /vagrant/dctl.rb /usr/local/bin/dctl
ln -s /vagrant/docker/drun.sh /usr/local/bin/drun

# Install storm, for ssh key management
pip install stormssh

# Run the registry - background this because it takes a while
docker run -d -p 5000:5000 registry &