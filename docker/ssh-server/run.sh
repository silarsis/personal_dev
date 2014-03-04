#!/bin/bash
run () {
	[ -e ${DIRNAME}/id_rsa ] || ssh-keygen -f ${DIRNAME}/id_rsa -N ""
	echo ${RUN_DOCKER} -d ${CONTAINER_NAME} ${CMD}
	CID=$(${RUN_DOCKER} -d ${CONTAINER_NAME} ${CMD})
	sshConfig
}