#!/bin/bash
DIRNAME="$( basename "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" )"
CONTAINER_NAME="$( basename ${DIRNAME} )"

docker run -v /ansible -name DATA busybox true
docker run -t -i -rm -volumes-from DATA -name ${CONTAINER_NAME} ${DIRNAME}