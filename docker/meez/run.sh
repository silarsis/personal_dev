#!/bin/bash
DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONTAINER_NAME="$( basename ${DIRNAME} )"
echo "Running ${CONTAINER_NAME} in ${DIRNAME}"

NUM_IMAGES=$(docker images ${CONTAINER_NAME} | grep -v REPOSITORY | wc -l)
if [ $NUM_IMAGES -lt 1 ]; then
	docker build -q -t ${CONTAINER_NAME} ${DIRNAME}
	IID=$(docker images ${CONTAINER_NAME} | grep -v REPOSITORY | awk '{ print $3 }')
	docker tag ${IID} localhost:5000/${CONTAINER_NAME}
	docker push localhost:5000/${CONTAINER_NAME}
fi
exec docker run -i -t ${CONTAINER_NAME}