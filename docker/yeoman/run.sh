#!/bin/bash

set -e

[ -e /vagrant/docker/yeoman/id_rsa ] || ssh-keygen -f /vagrant/docker/yeoman/id_rsa -N ''
NUM_IMAGES=$(docker images yeoman | wc -l)
if [ $NUM_IMAGES -lt 2 ]; then
	docker build -q -t yeoman /vagrant/docker/yeoman/
	IID=$(docker images yeoman | grep -v REPOSITORY | awk '{ print $3 }')
	docker tag ${IID} localhost:5000/yeoman
	docker push localhost:5000/yeoman
fi
CID=$(docker run -d --expose=22 $@ yeoman)
IP=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' ${CID})
IFS='.' read -ra ADDR <<< "$IP"
NAME="yeoman${ADDR[3]}"
[ "$(storm search ${NAME})" != "no results found." ] && storm delete ${NAME}
storm add --id_file /vagrant/docker/yeoman/id_rsa ${NAME} yeoman@${IP} --o "StrictHostKeyChecking=no" --o "UserKnownHostsFile=/dev/null"
