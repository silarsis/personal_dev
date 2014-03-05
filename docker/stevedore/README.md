stevedore
=========

Spike to try and build a CI server based on Docker

This project should provide a server that accepts notifications from github, and triggers git clone and docker commands. The plan is to have everything checked into the repository itself - the description of how the server should look, how the tests should be run, and eventually how the system should be deployed. The CI server itself should be standalone with almost no configuration whatsoever.

This system makes a number of strong assumptions:

1) The CI server will be run on an AWS instance (a Vagrantfile is provided to assist with this)
2) The code will be hosted on github

Dockerfile will be used per project to define the server configuration
There will be a YAML file that defines the entry points for testing, deployment and notifications
Stevedore will lean on standard deployment tools (ansible etc) for deployment
Stevedore will lean on standard test suite tools (language-specific) for testing
Stevedore will test itself