#!/bin/bash

run () {
    ${RUN_DOCKER} -it -v /home/core/share:/home/silarsis/share -v /home/core/share/.credulous:/home/silarsis/.credulous -v /home/core/share/.ssh:/home/silarsis/.ssh ${CONTAINER_NAME} ${CMD}
}
