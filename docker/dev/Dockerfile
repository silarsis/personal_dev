FROM credulous
RUN apt-get -yq install git less vim sudo
RUN useradd silarsis
RUN echo 'silarsis ALL = NOPASSWD: ALL' >> /etc/sudoers
USER silarsis
ENV HOME /home/silarsis
RUN curl -sSL https://get.rvm.io | sudo bash -s -- --ignore-dotfiles
RUN sudo usermod silarsis -G rvm
RUN bash -c "source /etc/profile.d/rvm.sh && rvmsudo_secure_path=1 rvmsudo rvm get stable --auto-dotfiles"
RUN bash -c "source /etc/profile.d/rvm.sh && rvm fix-permissions system"
RUN bash -c "source /etc/profile.d/rvm.sh && rvm rvmrc warning ignore all.rvmrcs"
RUN bash -c "source /etc/profile.d/rvm.sh && rvm install ruby-2.1.1"
ENV rvm_trust_rvmrcs_flag 1
USER root
ADD . /opt/dev
VOLUME /home/silarsis
CMD /opt/dev/start.sh
