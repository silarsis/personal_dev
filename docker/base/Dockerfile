FROM ubuntu:saucy
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
ENV DEBIAN_FRONTEND noninteractive
ADD detect-http-proxy /etc/apt/detect-http-proxy
ADD s30detectproxy /etc/apt/apt.conf.d/s30detectproxy
RUN chmod 755 /etc/apt/detect-http-proxy /etc/apt/apt.conf.d/s30detectproxy
RUN apt-get -yq update && apt-get -yq upgrade

# Strange little bug in /tmp permissions
RUN chmod go+w,u+s /tmp

# Fake a fuse install
RUN apt-get install libfuse2
RUN mkdir /tmp/fuse && \
	cd /tmp/fuse && \
	apt-get download fuse && \
	dpkg-deb -x fuse_* . && \
	dpkg-deb -e fuse_* && \
	rm fuse_*.deb && \
	echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst && \
	dpkg-deb -b . /fuse.deb && \
	dpkg -i /fuse.deb && \
	cd / && \
	rm -rf /tmp/fuse /fuse.deb

# Fix initctl, in case it hasn't been fixed already
RUN dpkg-divert --local --rename --add /sbin/initctl && rm -f /sbin/initctl && ln -s /bin/true /sbin/initctl

# Fix the locale
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

# Install some stuff I want by default
RUN apt-get -yq install vim telnet wget

# Quick clean-up to reduce the size of this image
RUN apt-get clean

CMD ["/bin/bash"]
