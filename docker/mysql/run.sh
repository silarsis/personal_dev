#!/bin/bash
run () { ${RUN_DOCKER} -d -p 3306:3306 ${CONTAINER_NAME} ${CMD}; }