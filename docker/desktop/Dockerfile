# This file creates a container that runs X11 and SSH services
# The ssh is used to forward X11 and provide you encrypted data
# communication between the docker container and your local 
# machine.
#
# Xpra allows to display the programs running inside of the
# container such as Firefox, LibreOffice, xterm, etc. 
# with disconnection and reconnection capabilities
#
# Xephyr allows to display the programs running inside of the
# container such as Firefox, LibreOffice, xterm, etc. 
#
# Fluxbox and ROX-Filer creates a very minimalist way to 
# manages the windows and files.
#
# Author: Roberto Gandolfo Hashioka
# Date: 07/28/2013


FROM ubuntu:saucy
MAINTAINER Roberto G. Hashioka "roberto_hashioka@hotmail.com"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -yq update && apt-get -yq upgrade

# Winswitch, experimental
RUN apt-get -yq install curl && curl http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ quantal main" > /etc/apt/sources.list.d/winswitch.list

# Set the env variable DEBIAN_FRONTEND to noninteractive

# Fake a fuse install
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

# Upstart and DBus have issues inside docker. We work around in order to install firefox.
RUN dpkg-divert --local --rename --add /sbin/initctl && rm -f /sbin/initctl && ln -s /bin/true /sbin/initctl

# Installing the required environment
RUN apt-get install -y xpra rox-filer ssh pwgen xserver-xephyr xdm fluxbox firefox xterm winswitch

# Configuring xdm to allow connections from any IP address and ssh to allow X11 Forwarding. 
RUN sed -i 's/DisplayManager.requestPort/!DisplayManager.requestPort/g' /etc/X11/xdm/xdm-config
RUN sed -i '/#any host/c\*' /etc/X11/xdm/Xaccess
RUN ln -s /usr/bin/Xorg /usr/bin/X
RUN echo X11Forwarding yes >> /etc/ssh/ssh_config

# Set locale (fix the locale warnings)
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || :

# Copy the files into the container
ADD . /src

# Add the local user
RUN adduser --disabled-password --gecos "" silarsis \
  && echo "silarsis ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
  && echo 'silarsis:passwd' | chpasswd
RUN mkdir -p /var/run/sshd
RUN cd /src/config/ && sudo -u silarsis cp -R .[a-z]* [a-z]* /home/silarsis/

EXPOSE 22
# Start xdm and ssh services.
CMD ["/bin/bash", "/src/startup.sh"]
