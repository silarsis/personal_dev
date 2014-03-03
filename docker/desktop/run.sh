#!/bin/bash
run () { CID=$(${RUN_DOCKER} -d -p 5900:22 ${CONTAINER_NAME} ${CMD}); docker logs $CID | grep '^User:'; }