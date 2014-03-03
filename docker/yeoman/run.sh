#!/bin/bash
run () { ${RUN_DOCKER} -P -d $@ ${CONTAINER_NAME} ${CMD}; }