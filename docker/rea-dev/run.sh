#!/bin/bash

build () {
    [ -z "$BUILD_ONLY" ] && veval "${SOURCE}" -b "${QUIETFLAG}" dev
    veval "${BUILD_DOCKER}" "${QUIETFLAG}" --rm -t "${CONTAINER_NAME}" "${DIRNAME}"
    veval docker tag "${CONTAINER_NAME}" "${USERNAME}"/"${CONTAINER_NAME}"
}

run () {
    ${RUN_DOCKER} -it \
      -v ~:/Users/silarsis \
      -v ~/.rea-aminate:/home/silarsis/.rea-aminate \
      -v ~/.rea-assuming:/home/silarsis/.rea-assuming \
      -v ~/.ssh:/home/silarsis/.ssh \
      -v /var/run/docker.sock:/var/run/docker.sock \
      --volumes-from rvm \
      "${CONTAINER_NAME}" "${CMD}"
}
