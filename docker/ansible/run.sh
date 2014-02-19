#!/bin/bash
docker run -v /ansible -name DATA busybox true
docker run -t -i -rm -volumes-from DATA -name ansible /vagrant/docker/ansible/