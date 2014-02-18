FROM ubuntu:quantal
MAINTAINER Kevin Littlejohn "kevin@littlejohn.id.au"
RUN apt-get -y -q update; \
  apt-get -y -q upgrade; \
  apt-get -y -q install openssh-server; \
  mkdir -p /var/run/sshd; \
  mkdir /root/.ssh && chmod 700 /root/.ssh
# Add our ssh key
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys && chown root. /root/.ssh/authorized_keys
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
