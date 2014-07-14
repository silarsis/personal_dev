FROM credulous
RUN apt-get -yq install git less vim sudo strace
RUN adduser --gecos '' --disabled-password silarsis
RUN echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
USER silarsis
ENV HOME /home/silarsis
RUN curl -sSL https://get.rvm.io | bash
RUN bash -l -c "rvm install ruby-2.1.1"
RUN echo 'export PS1="\[\033[0;31m\][Ruby-Dev-Docker]\[\033[0m\]:\u:\w\$ "' >> /home/silarsis/.bashrc
RUN echo 'rvm rvmrc warning ignore all.rvmrcs' >> /home/silarsis/.bashrc
RUN echo 'rvm use' >> /home/silarsis/.bash_profile
RUN git config --global color.ui auto
ENV rvm_trust_rvmrcs_flag 1
USER root
ADD start.sh /usr/local/bin/start.sh
VOLUME /home/silarsis
CMD /usr/local/bin/start.sh
