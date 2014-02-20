#!/bin/bash
[ -e /vagrant/docker/ssh-server/id_rsa ] || ssh-keygen -f /vagrant/docker/ssh-server/id_rsa -N ""
NUM_IMAGES=$(docker images ssh-server | wc -l)
if [ $NUM_IMAGES -lt 2 ]; then
	docker build -q -t ssh-server /vagrant/docker/ssh-server/
	IID=$(docker images ssh-server | grep -v REPOSITORY | awk '{ print $3 }')
	docker tag ${IID} localhost:5000/ssh-server
	docker push localhost:5000/ssh-server
fi
CID=$(docker run -d --expose=22 $@ ssh-server)
IP=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' ${CID})
IFS='.' read -ra ADDR <<< "$IP"
NAME="ssh${ADDR[3]}"
[ "$(storm search ${NAME})" != "no results found." ] && storm delete ${NAME}
storm add --id_file /vagrant/docker/ssh-server/id_rsa ${NAME} root@${IP} --o "StrictHostKeyChecking=no" --o "UserKnownHostsFile=/dev/null"
