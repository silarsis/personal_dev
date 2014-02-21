personal_dev
============

Personal Dev server, host for docker and openvswitch

Also includes docker repository and shipyard

The intention here is to have a single server that can spin up
docker containers for any given stack really quickly and easily.

OpenVSwitch allows for creating either a network of containers, or
potentially linking multiple servers (local or otherwise) via VPN
and running a single network across them.

So in theory, we should be able to use a single dev server as a
"command and control" point to either spin up a stack locally, or
drive creation of a dev server that can be accessed locally (not sure
about this).

Note, this is used as a general proving ground for things myself too -
it's public so I can refer people to useful bits
(Vagrantfile and bootstrap.sh are the most obvious, and maybe the
docker/*/(Dockerfile|run.sh) pattern if that's useful).