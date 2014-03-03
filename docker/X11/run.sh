#!/bin/bash
run () {
	${RUN_DOCKER} -d -p 5900:22 ${CONTAINER_NAME} ${CMD}
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
}