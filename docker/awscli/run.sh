#!/bin/bash

run () {
  ${RUN_DOCKER} -it \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_REGION \
    -v "$(pwd)":/container/ \
    "${CONTAINER_NAME}" "${CMD}"
}
