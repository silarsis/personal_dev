#!/bin/bash
docker build /vagrant/docker/chef-solo -t chef-solo
docker run chef-solo