#!/bin/bash

run () { CID=$(${RUN_DOCKER} -d ${CONTAINER_NAME} ${CMD}); }