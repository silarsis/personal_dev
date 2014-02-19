#!/bin/bash
docker build -t ssh-server /vagrant/docker/ssh-server/
CID=$(docker run -d --expose=22 ssh-server)
echo "IP Address: " `docker inspect -format '{{ .NetworkSettings.IPAddress }}' ${CID}`
# docker inspect to get the IP and display it