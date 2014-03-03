#!/bin/bash

run () {
	[ `docker ps -a | grep DATA` ] || docker run -v /ansible -name DATA busybox true
	docker run -t -i -rm -volumes-from DATA -name ${CONTAINER_NAME} ${CONTAINER_NAME}
}