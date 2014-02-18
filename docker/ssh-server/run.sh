#!/bin/bash
docker build -t ssh-server /vagrant/docker/ssh-server/
docker run ssh-server --expose=22
# docker inspect to get the IP and display it