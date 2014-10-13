FROM ubuntu:trusty
RUN apt-get -yq update && apt-get -yq upgrade
# Stuff I always want
RUN apt-get -yq install git less vim sudo strace lsof tmux make tcpdump netcat telnet curl dnsutils unzip groff jq uuid-runtime
RUN adduser --gecos '' --disabled-password silarsis
RUN echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker
USER silarsis
ENV HOME /home/silarsis
ENV CONTAINER_NAME Dev-Docker
RUN git config --global color.ui auto \
  && git config --global user.email "kevin@littlejohn.id.au" \
  && git config --global user.name "Kevin Littlejohn" \
  && git config --global push.default simple
USER root
RUN apt-get install -yq libxml2-dev libxslt1-dev

# Ruby
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN usermod -a -G rvm silarsis

# Python, for fig and the AWS CLI
RUN cd /usr/local/src \
  && curl -sSL https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz | tar zx \
  && cd Python-2.7.8 \
  && ./configure && make && make install \
  && cd /tmp \
  && curl -O https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py \
  && rm -rf /usr/local/src/Python-2.7.8 /tmp/get-pip.py
RUN pip install fig
RUN pip install awscli

# Keybase, for gpg
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get -yq install gnupg
RUN apt-get -yq install nodejs
RUN npm install -g keybase-installer
RUN keybase-installer

# Local scripts for configuration
ADD drun.sh /etc/profile.d/drun.sh
ADD tmux.conf /etc/tmux.conf
ADD start.sh /usr/local/bin/start.sh
ADD user_start.sh /usr/local/bin/user_start.sh
ADD container_name /usr/local/etc/container_name

RUN echo 'export PS1="\[\033[0;31m\][`cat /usr/local/etc/container_name`]\[\033[0m\]:\u:\w\$ "' >> /home/silarsis/.bashrc
ENTRYPOINT ["/usr/local/bin/start.sh"]

ONBUILD ADD container_name /usr/local/etc/container_name
