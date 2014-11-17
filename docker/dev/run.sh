#!/bin/bash

build () {
    veval docker pull "$(grep '^FROM' "${DIRNAME}"/Dockerfile | cut -d' ' -f2)"
    veval "${BUILD_DOCKER}" "${QUIETFLAG}" --rm -t "${CONTAINER_NAME}" "${DIRNAME}"
    veval docker tag "${CONTAINER_NAME}" "${USERNAME}"/"${CONTAINER_NAME}"
}

run () {
    ${RUN_DOCKER} --name ruby ruby ||:
    ${RUN_DOCKER} -it \
      -v ~:/Users/silarsis \
      -v ~/.ssh:/home/silarsis/.ssh \
      -v /var/run/docker.sock:/var/run/docker.sock \
      --volumes-from ruby \
      "${CONTAINER_NAME}" "${CMD}"
}
