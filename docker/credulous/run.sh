#!/bin/bash

run() {
    veval ${RUN_DOCKER} -i -t --rm -v ~/.credulous:/root/.credulous -v ~/.ssh:/root/.ssh ${CONTAINER_NAME} ${CMD}
}
