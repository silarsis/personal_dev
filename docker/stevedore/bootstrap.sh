#!/bin/bash
#
# Basic script to fire up a docker container with stevedore running in it

docker build -q -rm -t stevedore /vagrant
docker run -d stevedore