#!/bin/bash

run () { ${RUN_DOCKER} -i -t --link=mysql:mysql ${CONTAINER_NAME}; }
