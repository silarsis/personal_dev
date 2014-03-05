#!/bin/bash

run () {
	veval ${RUN_DOCKER} -d -p 8080:8080 -privileged -v /var/lib/jenkins:/var/lib/jenkins --name jenkins michaelneale/jenkins-docker-executors ${CMD}
}