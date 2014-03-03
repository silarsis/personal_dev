#!/bin/bash
run () { CID=$(docker run -P -d $@ ${CONTAINER_NAME}); }