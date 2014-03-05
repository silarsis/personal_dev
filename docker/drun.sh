#!/bin/bash
#
# Script to build, push, and run containers

USERNAME="silarsis" # Change this for the <username>/<image> tag name
REGISTRY="localhost:5000" # Change this for a different private registry location

set -e

BUILD_DOCKER="docker build"
RUN_DOCKER="docker run"
BUILD=0
PUSH=0
RUN=0

veval () {
	# Verbose eval
	echo $*
	eval $*
}

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

containerIP () {
	# Call with the container ID, sets ${IP}
	IP=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' $1)
}

sshConfig () {
	# Relies on the following being set: CID, DIRNAME
	containerIP ${CID}
	IFS='.' read -ra ADDR <<< "$IP"
	NAME="ssh${ADDR[3]}"
	if [ `which storm` ]; then
		[ "$(storm search ${NAME})" != "no results found." ] && storm delete ${NAME}
		storm add --id_file ${DIRNAME}/id_rsa ${NAME} root@${IP} --o "StrictHostKeyChecking=no" --o "UserKnownHostsFile=/dev/null"
	else
		cat << DELIM
Host ${NAME}
identityfile ${DIRNAME}/id_rsa
hostname ${IP}
user root
UserKnownHostsFile /dev/null
StrictHostKeyChecking no
port 22
DELIM
	fi
}

# Run by default
(( BUILD == PUSH == RUN == 0 )) && RUN=1

# Grab the container name and any trailing arguments
shift $(( ${OPTIND} - 1 ))
CONTAINER_NAME=$1
shift
CMD=$@

DIRNAME="/vagrant/docker/${CONTAINER_NAME}"

# Import any overrides for build, push and run
[ -e "${DIRNAME}/run.sh" ] && source "${DIRNAME}/run.sh"

# Default implementations of each of these
[ `type -t build` ] || build () {
	veval ${BUILD_DOCKER} -q -rm -t ${CONTAINER_NAME} ${DIRNAME}
	veval docker tag ${CONTAINER_NAME} ${USERNAME}/${CONTAINER_NAME}
}
[ `type -t run` ] || run () {
	veval exec ${RUN_DOCKER} -i -t ${CONTAINER_NAME} ${CMD}
}
[ `type -t push` ] || push () {
	veval docker tag ${CONTAINER_NAME} ${REGISTRY}/${CONTAINER_NAME}
	veval docker push ${REGISTRY}/${CONTAINER_NAME}
}

# Now, make it so...
[ ${BUILD} -eq 1 ] && { echo "Building..."; build; }
[ ${PUSH} -eq 1 ] && { echo "Pushing..."; push; }
[ ${RUN} -eq 1 ] && { echo "Running..."; run; }