#!/bin/bash

set -e

BUILD=0
PUSH=0
RUN=0

while getopts "bprh" opt; do
	case $opt in
		b)
			BUILD=1
		;;
		p)
			PUSH=1
		;;
		r)
			RUN=1
		;;
		h)
			echo "Usage: ${BASH_SOURCE[0]} [-b] [-p] [-r] <container name>"
			echo "build, push, run"
			exit 1
	esac
done

shift $(( ${OPTIND} - 1 ))
CONTAINER_NAME=${*}
DIRNAME="/vagrant/docker/${CONTAINER_NAME}"
echo "Running ${CONTAINER_NAME} in ${DIRNAME}"

[ -e "${DIRNAME}/run.sh" ] && source "${DIRNAME}/run.sh"

[ `type -t build` ] || build () { docker build -q -t ${CONTAINER_NAME} ${DIRNAME}; }
[ `type -t run` ] || run () { exec docker run -i -t ${CONTAINER_NAME}; }
[ `type -t push` ] || push () {
	IID=$(docker images ${CONTAINER_NAME} | grep -v REPOSITORY | awk '{ print $3 }')
	docker tag ${IID} localhost:5000/${CONTAINER_NAME}
	docker push localhost:5000/${CONTAINER_NAME}
}

[ ${BUILD} -eq 1 ] && { echo "Building..."; build; }
[ ${PUSH} -eq 1 ] && { echo "Pushing..."; push; }
[ ${RUN} -eq 1 ] && { echo "Running..."; run; }