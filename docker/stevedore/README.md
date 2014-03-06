stevedore
=========

Spike to try and build a CI server based on Docker

This project should provide a server that accepts notifications from github, and triggers git clone and docker commands. The plan is to have everything checked into the repository itself - the description of how the server should look, how the tests should be run, and eventually how the system should be deployed. The CI server itself should be standalone with almost no configuration whatsoever.

## Assumptions

1) The CI server will be run on an AWS instance (a Vagrantfile is provided to assist with this)
2) The code will be hosted on github
3) Dockerfile will be used per project to define the server configuration
4) There will be a YAML file that defines the entry points for testing, deployment and notifications
5) Stevedore will lean on standard deployment tools (ansible etc) for deployment
6) Stevedore will lean on standard test suite tools (language-specific) for testing
7) Stevedore will test itself

## Potential Issues

* Typically when you're testing a service, you're able to run the service and then run the tests on the same server. Docker containers run a little bit differently. Need to consider what the right answer to this is, or if there's a simple pattern that can be used to make this work.

* There's a challenge around dependencies and external requirements - need to think that through. This is where Dockerfiles fall down a bit, too.

## Notes

To run the server for development:

Terminal 1:
	docker run -p 3000:3000 -v /vagrant/docker/stevedore/stevedore:/opt/stevedore -i -t stevedore

Terminal 2:
	ngrok 3000

Update github.com to have the new forwarding address as the webhook (Settings -> Webhooks)