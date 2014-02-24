#!/bin/bash
DIRNAME="$( basename "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" )"
CONTAINER_NAME="$( basename ${DIRNAME} )"

NUM_IMAGES=$(docker images ${CONTAINER_NAME} | wc -l)
if [ $NUM_IMAGES -lt 2 ]; then
	docker build -q -t ${CONTAINER_NAME} ${DIRNAME}
	IID=$(docker images ${CONTAINER_NAME} | grep -v REPOSITORY | awk '{ print $3 }')
	docker tag ${IID} localhost:5000/${CONTAINER_NAME}
	docker push localhost:5000/${CONTAINER_NAME}
fi
CID=$(docker run -P -d $@ ${CONTAINER_NAME})