#!/bin/bash

build () {
    veval docker pull "$(grep '^FROM' "${DIRNAME}"/Dockerfile | cut -d' ' -f2)"
    veval "$0" "${QUIETFLAG}" -b gems
    veval "${BUILD_DOCKER}" "${QUIETFLAG}" --rm -t "${CONTAINER_NAME}" "${DIRNAME}"
    veval docker tag "${CONTAINER_NAME}" "${USERNAME}"/"${CONTAINER_NAME}"
}

run () {
    veval "$0" gems ||:
    ${RUN_DOCKER} -it \
      -v ~:/Users/silarsis \
      -v ~/.ssh:/home/silarsis/.ssh \
      -v /var/run/docker.sock:/var/run/docker.sock \
      --volumes-from gems \
      "${CONTAINER_NAME}" "${CMD}"
}
