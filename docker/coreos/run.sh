#!/bin/bash

build () {
    veval "${BUILD_DOCKER}" "${QUIETFLAG}" --rm -t "${CONTAINER_NAME}" "${DIRNAME}"
    veval docker tag "${CONTAINER_NAME}" "${USERNAME}"/"${CONTAINER_NAME}"
}

run () {
    ${RUN_DOCKER} -it \
      -v ~:/Users/silarsis \
      -v ~/.ssh:/home/silarsis/.ssh \
      -v /var/run/docker.sock:/var/run/docker.sock \
      "${CONTAINER_NAME}" "${CMD}"
}
