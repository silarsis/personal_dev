#!/bin/bash

run() {
  veval exec ${RUN_DOCKER} -v ~/host_home/scala:/opt/source -i -t ${CONTAINER_NAME} ${CMD}
}
