#!/bin/bash

run () {
    ${RUN_DOCKER} -it -v /home/core/share:/home/silarsis ${CONTAINER_NAME} ${CMD}
}
