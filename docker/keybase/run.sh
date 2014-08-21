#!/bin/bash

run () {
    ${RUN_DOCKER} -it \
      -v ~:/Users/silarsis \
      -v ~/.credulous:/home/silarsis/.credulous \
      -v ~/.ssh:/home/silarsis/.ssh \
      -v ~/.g
      -v /var/run/docker.sock:/var/run/docker.sock \
      "${CONTAINER_NAME}" "${CMD}"
}
