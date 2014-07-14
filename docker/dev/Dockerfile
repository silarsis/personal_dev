FROM credulous
RUN apt-get -yq install git less vim sudo strace
RUN adduser --gecos '' --disabled-password silarsis
RUN echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
USER silarsis
ENV HOME /home/silarsis
ENV CONTAINER_NAME Ruby-Dev-Docker
RUN git config --global color.ui auto

USER root
ADD start.sh /usr/local/bin/start.sh
ADD container_name /usr/local/etc/container_name
RUN echo 'export PS1="\[\033[0;31m\][`cat /usr/local/etc/container_name`]\[\033[0m\]:\u:\w\$ "' >> /home/silarsis/.bashrc
CMD /usr/local/bin/start.sh

ONBUILD ADD container_name /usr/local/etc/container_name
