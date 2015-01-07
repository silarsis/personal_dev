run() {
    ${RUN_DOCKER} -it -v `pwd`:/app ${CONTAINER_NAME} ${CMD}
}
