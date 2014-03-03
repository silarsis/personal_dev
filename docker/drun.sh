#!/bin/bash

set -e

BUILD=0
BUILD_DOCKER="docker build"
PUSH=0
RUN=0
RUN_DOCKER="docker run"

while getopts ":bB:prR:c:h" opt; do
	case $opt in
		b)
			BUILD=1
			;;
		B)
			BUILD_DOCKER="${BUILD_DOCKER} ${OPTARG}"
			;;
		p)
			PUSH=1
			;;
		r)
			RUN=1
			;;
		R)
			RUN_DOCKER="${RUN_DOCKER} ${OPTARG}"
			;;
		h)
			echo "Usage: ${BASH_SOURCE[0]} [-b] [-p] [-r] [-B '--no-cache'] [ -R '-P'] <container name>"
			echo "build, push, run"
			echo "-B and -R let you specify build and run arguments"
			exit 1
			;;
	esac
done

shift $(( ${OPTIND} - 1 ))
CONTAINER_NAME=${*}
CMD=$@
DIRNAME="/vagrant/docker/${CONTAINER_NAME}"
echo "Running ${CONTAINER_NAME} in ${DIRNAME}"

[ -e "${DIRNAME}/run.sh" ] && source "${DIRNAME}/run.sh"

[ `type -t build` ] || build () {
	echo ${BUILD_DOCKER} -q -rm -t ${CONTAINER_NAME} ${DIRNAME}
	${BUILD_DOCKER} -q -rm -t ${CONTAINER_NAME} -t silarsis/${CONTAINER_NAME} ${DIRNAME}
}
[ `type -t run` ] || run () {
	echo exec ${RUN_DOCKER} -i -t ${CONTAINER_NAME} ${CMD}
	exec ${RUN_DOCKER} -i -t ${CONTAINER_NAME} ${CMD}
}
[ `type -t push` ] || push () {
	IID=$(docker images -q ${CONTAINER_NAME} | head -1)
	echo docker tag ${IID} localhost:5000/${CONTAINER_NAME}
	docker tag ${IID} localhost:5000/${CONTAINER_NAME}
	docker push localhost:5000/${CONTAINER_NAME}
}

[ ${BUILD} -eq 1 ] && { echo "Building..."; build; }
[ ${PUSH} -eq 1 ] && { echo "Pushing..."; push; }
[ ${RUN} -eq 1 ] && { echo "Running..."; run; }