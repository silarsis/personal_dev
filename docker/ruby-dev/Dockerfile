FROM dev

USER silarsis
RUN curl -sSL https://get.rvm.io | bash
RUN bash -l -c "rvm install ruby-2.1.1"
RUN echo 'rvm rvmrc warning ignore all.rvmrcs' >> /home/silarsis/.bashrc
RUN echo 'rvm use' >> /home/silarsis/.bash_profile
ENV rvm_trust_rvmrcs_flag 1
USER root
RUN cd /tmp && git clone https://github.com/github/hub.git && cd hub && rake install prefix=/usr/local
