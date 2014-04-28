#!/bin/bash

run() {
  veval exec ${RUN_DOCKER} -v ~/host_home/coursera-scala:/opt/progfun -i -t ${CONTAINER_NAME} ${CMD}
}
