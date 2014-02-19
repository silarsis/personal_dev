#!/bin/bash
docker build -q -t firefox /vagrant/docker/firefox

docker run -P -p 5900 /vagrant/docker/firefox