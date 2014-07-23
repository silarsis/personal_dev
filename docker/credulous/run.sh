#!/bin/bash

run() {
    veval ${RUN_DOCKER} -i -t --rm -v $HOME/.credulous:/root/.credulous -v $HOME/.ssh:/root/.ssh -v $HOME:$HOME ${CONTAINER_NAME} ${CMD}
}
