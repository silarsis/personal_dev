FROM credulous
RUN apt-get -yq install git less vim sudo
RUN useradd silarsis
RUN echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
USER silarsis
ENV HOME /home/silarsis
RUN curl -sSL https://get.rvm.io | sudo bash -s -- --ignore-dotfiles
RUN sudo usermod silarsis -G rvm
RUN bash -c "source /etc/profile.d/rvm.sh && rvm install ruby-2.1.1"
USER root
RUN /usr/local/rvm/bin/rvm rvmrc warning ignore all.rvmrcs
RUN deluser -q silarsis
ADD . /opt/dev
VOLUME /home/silarsis
CMD /opt/dev/start.sh
