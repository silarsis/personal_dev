#!/bin/bash
DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONTAINER_NAME="$( basename ${DIRNAME} )"

NUM_IMAGES=$(docker images ${CONTAINER_NAME} | wc -l)
if [ $NUM_IMAGES -lt 2 ]; then
	docker build -q -t ${CONTAINER_NAME} ${DIRNAME}
	IID=$(docker images ${CONTAINER_NAME} | grep -v REPOSITORY | awk '{ print $3 }')
	docker tag ${IID} localhost:5000/${CONTAINER_NAME}
	docker push localhost:5000/${CONTAINER_NAME}
fi

docker run -d -p 5900:22 ${CONTAINER_NAME}

IP=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' ${CID})
IFS='.' read -ra ADDR <<< "$IP"
NAME="ssh${ADDR[3]}"
if [ `which storm` ]; then
	[ "$(storm search ${NAME})" != "no results found." ] && storm delete ${NAME}
	storm add --id_file ${DIRNAME}/id_rsa ${NAME} root@${IP} --o "StrictHostKeyChecking=no" --o "UserKnownHostsFile=/dev/null"
else
	cat << DELIM
Host ${name}
    identityfile ${DIRNAME}/id_rsa
    hostname ${IP}
    user root
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    port 22
DELIM
fi
