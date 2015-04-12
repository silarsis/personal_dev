#!/bin/bash

build () {
    veval "${DOCKER_CMD}" pull "$(grep '^FROM' "${DIRNAME}"/Dockerfile | cut -d' ' -f2)"
    veval "${BUILD_DOCKER}" "${QUIETFLAG}" --rm -t "${CONTAINER_NAME}" "${DIRNAME}"
    veval "${DOCKER_CMD}" tag -f "${CONTAINER_NAME}" "${USERNAME}"/"${CONTAINER_NAME}"
}

run () {
    ${RUN_DOCKER} --name ruby silarsis/ruby >/dev/null ||:
    veval ${RUN_DOCKER} -it \
      -v "${HOME}":"${HOME}" \
      -v "${DOCKER_CERT_PATH}":"${DOCKER_CERT_PATH}" \
      -e DOCKER_TLS_VERIFY \
      -e DOCKER_CERT_PATH \
      -e DOCKER_HOST \
      -e USERNAME="$(id -u -n)" \
      -e MOUNTED_DIR="${HOME}" \
      --volumes-from ruby \
      "${CONTAINER_NAME}" "${CMD}"
}
