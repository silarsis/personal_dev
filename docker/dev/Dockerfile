FROM ubuntu:trusty
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

# Add docker apt repository
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 \
  && echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get -yq update && apt-get -yq upgrade

# Stuff I always want or requirements for compiling things
RUN apt-get -yq install less vim sudo strace lsof tmux make tcpdump netcat \
    telnet curl dnsutils unzip groff jq uuid-runtime wget \
    gcc zlib1g-dev libxml2-dev libxslt1-dev libssl-dev libreadline6-dev \
    libyaml-0-2 libcurl4-gnutls-dev libexpat1-dev gettext libz-dev

# Git from source after a security issue
RUN cd /usr/local/src \
  && wget https://www.kernel.org/pub/software/scm/git/git-2.2.1.tar.gz \
  && tar zxf git*.tar.gz \
  && cd git* \
  && ./configure && make && make install \
  && rm -rf /usr/local/src/git*

# Docker
RUN apt-get -yq install lxc-docker-1.3.3

# Python
RUN cd /usr/local/src \
  && curl -sSL https://www.python.org/ftp/python/2.7.8/Python-2.7.8.tgz | tar zx \
  && cd Python-2.7.8 \
  && ./configure && make && make install \
  && cd /tmp \
  && curl -O https://bootstrap.pypa.io/get-pip.py && python /tmp/get-pip.py \
  && rm -rf /usr/local/src/Python-2.7.8 /tmp/get-pip.py
RUN pip install awscli

# Keybase, for gpg
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get -yq install gnupg nodejs
RUN npm install -g keybase-installer
RUN keybase-installer

# Local scripts for configuration
ADD drun.sh /etc/profile.d/drun.sh
ADD tmux.conf /etc/tmux.conf
ADD start.sh /usr/local/bin/start.sh
ADD user_start.sh /usr/local/bin/user_start.sh
ADD container_name /usr/local/etc/container_name

# Configure my user
RUN adduser --gecos '' --disabled-password silarsis
RUN echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
USER silarsis
ENV HOME /home/silarsis
RUN git config --global color.ui auto \
  && git config --global user.email "kevin@littlejohn.id.au" \
  && git config --global user.name "Kevin Littlejohn" \
  && git config --global push.default simple
ADD bash_profile /home/silarsis/.bash_profile
USER root

ENTRYPOINT ["/usr/local/bin/start.sh"]

ONBUILD ADD container_name /usr/local/etc/container_name
