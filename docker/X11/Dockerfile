# Firefox over VNC

FROM ubuntu:saucy
MAINTAINER Kevin Littlejon <kevin@littlejohn.id.au>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -yq update && apt-get -yq upgrade

# Fake a fuse install
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

# Install vnc, xvfb in order to create a 'fake' display and firefox
RUN apt-get install -yq xpra rox-filer ssh pwgen xserver-xephyr xdm fluxbox xterm firefox x11vnc xvfb 

# Add a user to run under
RUN adduser --disabled-password --gecos "" silarsis; \
  echo "silarsis ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/silarsis
USER silarsis

ADD startup.sh /usr/local/bin/startup.sh

# Note, we only ever run one copy of this...
EXPOSE 5900
CMD ["/usr/local/bin/startup.sh"]