#!/bin/bash
[ -e /vagrant/docker/nodejs/id_rsa ] || ssh-keygen -f /vagrant/docker/nodejs/id_rsa -N ""
NUM_IMAGES=$(docker images nodejs | wc -l)
if [ $NUM_IMAGES -lt 2 ]; then
	docker build -q -t nodejs /vagrant/docker/nodejs/
	IID=$(docker images nodejs | grep -v REPOSITORY | awk '{ print $3 }')
	docker tag ${IID} localhost:5000/nodejs
	docker push localhost:5000/nodejs
fi
CID=$(docker run -d --expose=22 $@ nodejs)
IP=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' ${CID})
IFS='.' read -ra ADDR <<< "$IP"
NAME="nodejs${ADDR[3]}"
[ "$(storm search ${NAME})" != "no results found." ] && storm delete ${NAME}
storm add --id_file /vagrant/docker/nodejs/id_rsa ${NAME} root@${IP} --o "StrictHostKeyChecking=no" --o "UserKnownHostsFile=/dev/null"
