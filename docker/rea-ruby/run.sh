#!/bin/bash

run () {
    ${RUN_DOCKER} --name ${CONTAINER_NAME} ${CONTAINER_NAME} 2>/dev/null ||:
}
