#!/bin/bash

run () {
  mkdir -p /var/cache/angry-caching-proxy
  veval ${RUN_DOCKER} -d -p 3142:8080 -v /var/cache/angry-caching-proxy:/angry-caching-proxy:rw --name angry-caching-proxy ${CONTAINER_NAME} ${CMD}
}
