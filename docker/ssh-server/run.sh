#!/bin/bash
docker build -q -t ssh-server /vagrant/docker/ssh-server/ | grep 'Successfully built'
CID=$(docker run -d --expose=22 $@ ssh-server)
IP=$(docker inspect -format '{{ .NetworkSettings.IPAddress }}' ${CID})
IFS='.' read -ra ADDR <<< "$IP"
storm add --id_file /vagrant/docker/ssh-server/id_rsa "ssh${ADDR[3]}" root@${IP} --o "StrictHostKeyChecking=no" --o "UserKnownHostsFile=/dev/null"
