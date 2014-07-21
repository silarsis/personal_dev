#!/bin/bash

build () {
    veval ${SOURCE} -b ${QUIETFLAG} credulous
    veval ${BUILD_DOCKER} ${QUIETFLAG} --rm -t ${CONTAINER_NAME} ${DIRNAME}
    veval docker tag ${CONTAINER_NAME} ${USERNAME}/${CONTAINER_NAME}
}

run () {
    ${RUN_DOCKER} -it -v /home/core/share:/home/silarsis/share -v /home/core/share/.credulous:/home/silarsis/.credulous -v /home/core/share/.ssh:/home/silarsis/.ssh -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/local/bin/docker ${CONTAINER_NAME} ${CMD}
}
