This directory holds templates for chef installs.

The files in this directory are configured to run "kibana",
because the instructions came from
http://tech.paulcz.net/2013/09/creating-immutable-servers-with-chef-and-docker-dot-io.html

Instructions:

* mkdir docker/chef-nginx/
* copy chef/* docker/chef-nginx
* edit chef.json, Berksfile, yaml and Dockerfile for your services
* dctl -f kibana provision