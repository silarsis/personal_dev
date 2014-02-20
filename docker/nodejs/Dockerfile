# Nodejs server
FROM localhost:5000/ssh-server
MAINTAINER Kevin Littlejohn "kevin@littlejohn.id.au"
RUN apt-get -y -q update; \
  apt-get -y -q upgrade; \
  apt-get -y -q install python-software-properties software-properties-common python g++ make; \
  add-apt-repository ppa:chris-lea/node.js -y; \
  apt-get -y -q update; \
  apt-get -y -q install nodejs
# Add our ssh key
ADD id_rsa.pub /root/.ssh/authorized_keys
RUN chmod 400 /root/.ssh/authorized_keys && chown root. /root/.ssh/authorized_keys
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
