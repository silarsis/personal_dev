#!/bin/bash

run() {
    veval ${RUN_DOCKER} -i -t --rm -v /home/core/share/.credulous:/root/.credulous -v /home/core/share/.ssh:/root/.ssh ${CONTAINER_NAME} ${CMD}
}
