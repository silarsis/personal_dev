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

### Configure swap on the host - 2Gb
```
dd if=/dev/zero of=/swapfile bs=1024 count=2048k
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' >> /etc/fstab
echo 10 > /proc/sys/vm/swappiness
echo 'vm.swappiness = 10' >> /etc/sysctl.conf
```

### IPTables entry to redirect all docker port 80 requests to a transparent proxy on port 3128
(but, see https://github.com/silarsis/docker-proxy)
```
iptables -t nat -A PREROUTING -i docker0 -p tcp --dport 80 -j REDIRECT --to-port 3128
```

### Fake a fuse install
```
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb
```

### Fix the locale:
```
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :
```

### Fix initctl
```
RUN dpkg-divert --local --rename --add /sbin/initctl && rm -f /sbin/initctl && ln -s /bin/true /sbin/initctl
```

### Install a user:
```
RUN adduser --disabled-password --gecos "" silarsis; \
  echo "silarsis ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/silarsis
USER silarsis
WORKDIR /home/silarsis
```

### Delete all unused containers:
```
docker ps -a | grep Exit | awk '{ print $1 }' | xargs -r docker rm
```

### Delete all untagger dangling images:
```
docker rmi $(docker images -f "dangling=true" -q)
```

### Find the IP of a container:
```
docker inspect --format '{{ .NetworkSettings.IPAddress }}' <containerid>
```

### Register the hostname in /etc/hosts
```
if [ ! sed '/\([0-9\.]*\) registry.dev/,${s//'"${IP}"' registry.dev/;b};$q1' /etc/hosts ]; then
	echo "${IP} registry.dev" >> /etc/hosts
end
```

### Make changes to the docker container /etc/hosts
```
RUN cp /etc/hosts /tmp/hosts
RUN echo "x.x.x.x something" >> /tmp/hosts
RUN mkdir -p -- /lib-override && cp `find / -iname libnss_files.so.2` /lib-override
RUN perl -pi -e 's:/etc/hosts:/tmp/hosts:g' /lib-override/libnss_files.so.2
ENV LD_LIBRARY_PATH /lib-override
```

### Commit an image ready to be run again, with /bin/bash as the command
```
docker commit -run='{"Cmd":["/bin/bash"], "User":"root"}' <containerID> <tag>
```

### Increase the size of the coreos filesystem

Find the vmdk (start virtualbox ui, right click on vm and "show in finder"
```
VBoxManage showhdinfo <filename>
```
Get the UUID from the error you see from the above command, then:
```
VBoxManage clonehd --format VDI <uuid> <newfilename.vdi>
VBoxManage modifyhd <newfilename.vdi> --resize 81920
```

Go into VirtualBox, settings for the vm, storage, remove the existing drive and add the new one.

### Location of OS X docker binary

http://get.docker.io/builds/Darwin/x86_64/docker-$version.tgz
