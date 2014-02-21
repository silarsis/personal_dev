This directory contains a dir per Docker container.

There is a pattern to the files in this dir. The important
files as at time of writing are:

* Dockerfile - the docker definition for the given service/container
* run.sh - a utility script to start a given container

Sometimes when these dockers are hardened appropriately they'll be
exported out to their own github repo (as happened to yeoman) and
turned into a trusted build on index.docker.io

There are some other older files in here too - the "yaml" files
work with dctl.rb to try and provide for another way to manage docker
containers. I'm not convinced the design is right/good, though, so
consider them deprecated for now.