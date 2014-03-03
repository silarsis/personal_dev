#!/bin/bash
run () { docker run -d -p 3306:3306 ${CONTAINER_NAME}; }