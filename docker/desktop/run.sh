#!/bin/bash
run () { CID=$(docker run -d -p 5900:22 ${CONTAINER_NAME}); docker logs $CID | grep '^User:'; }