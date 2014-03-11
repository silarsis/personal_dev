#!/bin/bash

# This override repoints to github
DIRNAME=github.com/silarsis/stevedore

run () {
	veval ${RUN_DOCKER} -d -p 3000:3000 silarsis/stevedore ${CMD}
}