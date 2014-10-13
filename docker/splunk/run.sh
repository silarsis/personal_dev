#!/bin/bash

run () {
    ${RUN_DOCKER} -it -v /tmp/splunk:/opt/splunk/var "${CONTAINER_NAME}" "${CMD}"
}
