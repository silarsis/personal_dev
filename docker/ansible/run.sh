#!/bin/bash

run () {
	[ `docker ps -a | grep DATA` ] || veval ${BUILD_DOCKER} -v /ansible -name DATA busybox true
	veval ${RUN_DOCKER} -t -i -rm -volumes-from DATA -name ${CONTAINER_NAME} ${CONTAINER_NAME} ${CMD}
}