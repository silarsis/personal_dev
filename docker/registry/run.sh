#!/bin/bash
run () {
	echo ${RUN_DOCKER} -d -p 5000:5000 -v /tmp/registry:/tmp/registry --name=registry registry ${CMD}
	${RUN_DOCKER} -d -p 5000:5000 -v /tmp/registry:/tmp/registry --name=registry registry ${CMD}
}