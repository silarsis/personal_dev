#!/bin/bash

run () {
  veval ${RUN_DOCKER} -d --name reapgsql ${CONTAINER_NAME} ${CMD}
}
