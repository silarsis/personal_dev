#!/bin/bash

run () {
	echo ${RUN_DOCKER} -p 8080:8080 -privileged michaelneale/jenkins-docker-executors ${CMD}
	${RUN_DOCKER} -p 8080:8080 -privileged michaelneale/jenkins-docker-executors ${CMD}
}