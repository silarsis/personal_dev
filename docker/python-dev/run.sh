#!/bin/bash

build () {
    veval ${SOURCE} -b ${QUIETFLAG} dev
    veval ${BUILD_DOCKER} ${QUIETFLAG} --rm -t ${CONTAINER_NAME} ${DIRNAME}
    veval docker tag ${CONTAINER_NAME} ${USERNAME}/${CONTAINER_NAME}
}

run () {
    ${RUN_DOCKER} -it -v /home/core/share:/home/silarsis/share -v /home/core/share/.credulous:/home/silarsis/.credulous -v /home/core/share/.ssh:/home/silarsis/.ssh ${CONTAINER_NAME} ${CMD}
}
