run () {
    XVOL=${DISPLAY+"-v $(dirname $DISPLAY):$(dirname $DISPLAY)"}
    XENV=${DISPLAY+"-e DISPLAY=$DISPLAY"}
    ${RUN_DOCKER} -it \
      -v ~:/Users/silarsis \
      -v ~/.credulous:/home/silarsis/.credulous \
      -v ~/.ssh:/home/silarsis/.ssh \
      -v /var/run/docker.sock:/var/run/docker.sock \
      ${XVOL} ${XENV} "${CONTAINER_NAME}" "${CMD}"
}
