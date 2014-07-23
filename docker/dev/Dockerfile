FROM credulous
# Stuff I always want
RUN apt-get -yq install git less vim sudo strace lsof tmux make
RUN adduser --gecos '' --disabled-password silarsis
RUN echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
RUN chmod +x /usr/local/bin/docker
USER silarsis
ENV HOME /home/silarsis
ENV CONTAINER_NAME Dev-Docker
RUN git config --global color.ui auto && git config --global user.email "kevin@littlejohn.id.au" && git config --global user.name "Kevin Littlejohn"
USER root

# Ruby, needed for hub
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.1"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN usermod -G rvm silarsis

# Local scripts for configuration
ADD tmux.conf /etc/tmux.conf
ADD start.sh /usr/local/bin/start.sh
ADD user_start.sh /usr/local/bin/user_start.sh
ADD container_name /usr/local/etc/container_name

#RUN cd /tmp && git clone git://github.com/github/hub.git && cd hub && rake install
RUN echo 'export PS1="\[\033[0;31m\][`cat /usr/local/etc/container_name`]\[\033[0m\]:\u:\w\$ "' >> /home/silarsis/.bashrc
ENTRYPOINT ["/usr/local/bin/start.sh"]

ONBUILD ADD container_name /usr/local/etc/container_name
