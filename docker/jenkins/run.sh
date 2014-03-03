#!/bin/bash

run () {
	echo ${RUN_DOCKER} -d -p 8080:8080 -privileged michaelneale/jenkins-docker-executors ${CMD}
	${RUN_DOCKER} -d -p 8080:8080 -privileged michaelneale/jenkins-docker-executors ${CMD}
}