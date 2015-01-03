#!/bin/bash

build () {
    [ -z "$BUILD_ONLY" ] && veval "${SOURCE}" -b "${QUIETFLAG}" dev
    veval "${SOURCE}" -b "${QUIETFLAG}" rea-ruby
    veval docker tag -f dev rea-dev
}

run () {
    ${RUN_DOCKER} --name rea-ruby rea-ruby ||:
    ${RUN_DOCKER} -it \
      -v ~:/Users/silarsis \
      -v ~/.rea-aminate:/home/silarsis/.rea-aminate \
      -v ~/.rea-assuming:/home/silarsis/.rea-assuming \
      -v ~/.ssh:/home/silarsis/.ssh \
      -v /var/run/docker.sock:/var/run/docker.sock \
      --volumes-from rea-ruby \
      "${CONTAINER_NAME}" "${CMD}"
}
