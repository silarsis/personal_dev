personal_dev
============

Personal Dev server, host for docker and any personal projects

Please see the bootstrap.sh for detailed information about what's installed.

The intention here is to have a single server that can spin up
docker containers for any given stack really quickly and easily.

OpenVSwitch allows for creating either a network of containers, or
potentially linking multiple servers (local or otherwise) via VPN
and running a single network across them.

So in theory, we should be able to use a single dev server as a
"command and control" point to either spin up a stack locally, or
drive creation of a dev server that can be accessed locally (not sure
about this).

Right now, this isn't being done - I've removed OpenVSwitch until I
have some time to really play with that.

Note, this is used as a general proving ground for things myself too -
it's public so I can refer people to useful bits
(Vagrantfile and bootstrap.sh are the most obvious, and maybe the
docker/*/(Dockerfile|run.sh) pattern if that's useful).

Oh, "drun.sh" in the docker/ directory provides a short-cut for running
any of the docker/*/run.sh scripts

## Snippets that are useful:

### Fake a fuse install
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

### Fix the locale:
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

### Fix initctl
RUN dpkg-divert --local --rename --add /sbin/initctl && rm -f /sbin/initctl && ln -s /bin/true /sbin/initctl

### Install a user:
RUN adduser --disabled-password --gecos "" silarsis; \
  echo "silarsis ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/silarsis
USER silarsis
WORKDIR /home/silarsis

### Delete all unused containers:
docker ps -a | grep Exit | awk '{ print $1 }' | xargs docker rm

### Find the IP of a container:
docker inspect -format '{{ .NetworkSettings.IPAddress }}' <containerid>


### Register the hostname in /etc/hosts
if [ ! sed '/\([0-9\.]*\) registry.dev/,${s//'"${IP}"' registry.dev/;b};$q1' /etc/hosts ]; then
	echo "${IP} registry.dev" >> /etc/hosts
end

### Commit an image ready to be run again, with /bin/bash as the command
docker commit -run='{"Cmd":["/bin/bash"], "User":"root"}' <containerID> <tag>
