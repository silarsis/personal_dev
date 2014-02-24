#!/bin/bash

if [ -e "/vagrant/docker/$1/run.sh" ]; then
	exec /vagrant/docker/$1/run.sh
else
	exec docker run $1
fi