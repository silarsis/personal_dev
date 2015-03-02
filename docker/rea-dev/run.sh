#!/bin/bash

build () {
    [ -z "$BUILD_ONLY" ] && veval "${SOURCE}" -b "${QUIETFLAG}" dev
    veval "${SOURCE}" -b "${QUIETFLAG}" rea-ruby
    veval docker tag -f dev rea-dev
}

run () {
    ${RUN_DOCKER} --name rea-ruby rea-ruby >/dev/null ||:
    ${RUN_DOCKER} -it \
      -v ${HOME}:${HOME} \
      -v /var/run/docker.sock:/var/run/docker.sock \
      --volumes-from rea-ruby \
      -e USERNAME="$(id -u -n)" \
      -e MOUNTED_DIR="${HOME}" \
      "${CONTAINER_NAME}" "${CMD}"
}
