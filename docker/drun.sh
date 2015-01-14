#!/bin/bash
#
# Script to build, push, and run containers

USERNAME="silarsis" # Change this for the <username>/<image> tag name
REGISTRY="localhost:5000" # Change this for a different private registry location

set -e

DOCKER_CMD="docker"
BUILD_DOCKER="${DOCKER_CMD} build"
RUN_DOCKER="${DOCKER_CMD} run"
BUILD=0
PUSH=0
RUN=0
QUIET=0
QUIETFLAG="-q"

# Swallow errors because sometimes we're using coreos not boot2docker
command -v boot2docker >/dev/null 2>&1 && $(boot2docker shellinit 2>/dev/null) ||:

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  TARGET="$(readlink "$SOURCE")"
  if [[ $SOURCE == /* ]]; then
    SOURCE="$TARGET"
  else
    SOURCEDIR="$( dirname "$SOURCE" )"
    SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
  fi
done
SOURCEDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

veval () {
    # Verbose eval
    (( QUIET == 0 )) && echo "$*"
    eval $*
}

while getopts ":sbB:prR:c:hvlfq" opt; do
    case $opt in
        s)
            echo "${SOURCEDIR}"
            exit
            ;;
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
        y)
            REGISTRY="${OPTARG}"
            ;;
        v)
            QUIETFLAG=""
            ;;
        q)
            QUIET=1
            ;;
        l)
            find -L ~/docker/ "${SOURCEDIR}" -maxdepth 1 -type d -exec basename {} \; 2>/dev/null | grep -v '^\docker$' | sort | uniq
            ;;
        f)
            # Relies on not being able to remove running containers
            ${DOCKER_CMD} rm $(${DOCKER_CMD} ps -aq) 2>/dev/null
            ${DOCKER_CMD} rmi $(${DOCKER_CMD} images -qf dangling=true) 2>/dev/null
            exit 0
            ;;
        h)
            echo "Usage: ${BASH_SOURCE[0]} [-v] [-b] [-p] [-r] [-y] [-B '--no-cache'] [ -R '-P'] <container name>"
            echo "build, push, run"
            echo "-B and -R let you specify build and run arguments"
            echo "-y lets you specify a new REGISTRY, for push"
            echo "-v for verbose (switch 'quiet' off for docker calls)"
            echo "-f to flush all non-running containers and non-tagged images older than a day"
            exit 1
            ;;
    esac
done

containerIP () {
    # Call with the container ID, sets ${IP}
    IP=$(${DOCKER_CMD} inspect --format '{{ .NetworkSettings.IPAddress }}' "$1")
}

sshConfig () {
    # Relies on the following being set: CID, DIRNAME
    containerIP "${CID}"
    IFS='.' read -ra ADDR <<< "$IP"
    NAME="ssh${ADDR[3]}"
    if [ "$(which storm)" ]; then
        [ "$(storm search "${NAME}")" != "no results found." ] && storm delete "${NAME}"
        storm add --id_file "${DIRNAME}"/id_rsa "${NAME}" root@"${IP}" --o "StrictHostKeyChecking=no" --o "UserKnownHostsFile=/dev/null"
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
shift $(( OPTIND - 1 ))
CONTAINER_NAME=$1
shift
CMD=$@

# Find the container
DIRNAME=~/docker/${CONTAINER_NAME}
if [ ! -d "${DIRNAME}" ]; then
    DIRNAME="${SOURCEDIR}/${CONTAINER_NAME}"
    if [ ! -d "${DIRNAME}" ]; then
        echo "No docker configuration called '${CONTAINER_NAME}' found"
        exit 1
    fi
fi

# Import any overrides for build, push and run
[ -e "${DIRNAME}/run.sh" ] && RUNNING_DRUN=1 source "${DIRNAME}/run.sh"

# Default implementations of each of these
[ "$(type -t build)" ] || build () {
    veval ${BUILD_DOCKER} ${QUIETFLAG} --rm -t "${CONTAINER_NAME}" "${DIRNAME}"
    veval ${DOCKER_CMD} tag -f "${CONTAINER_NAME}" ${USERNAME}/"${CONTAINER_NAME}"
}
[ "$(type -t run)" ] || run () {
    veval exec ${RUN_DOCKER} -i -t "${CONTAINER_NAME}" ${CMD}
}
[ "$(type -t push)" ] || push () {
    veval ${DOCKER_CMD} tag "${CONTAINER_NAME}" "${REGISTRY}"/"${CONTAINER_NAME}"
    veval ${DOCKER_CMD} push "${REGISTRY}"/"${CONTAINER_NAME}"
}

# Now, make it so...
[ ${BUILD} -eq 1 ] && { (( QUIET == 0 )) && echo "Building..."; build; }
[ ${PUSH} -eq 1 ] && { (( QUIET == 0 )) && echo "Pushing..."; push; }
[ ${RUN} -eq 1 ] && { (( QUIET == 0 )) && echo "Running..."; run; }
exit 0
