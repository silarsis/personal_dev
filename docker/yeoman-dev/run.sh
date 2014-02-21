#!/bin/bash
NUM_IMAGES=$(docker images yeoman-dev | wc -l)
if [ $NUM_IMAGES -lt 2 ]; then
	docker build -q -t yeoman-dev /vagrant/docker/yeoman-dev/
	IID=$(docker images yeoman-dev | grep -v REPOSITORY | awk '{ print $3 }')
	docker tag ${IID} localhost:5000/yeoman-dev
	docker push localhost:5000/yeoman-dev
fi
CID=$(docker run -P -d $@ yeoman-dev)