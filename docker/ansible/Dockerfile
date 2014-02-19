# Ansible "server"
FROM localhost:5000/ssh-server
MAINTAINER Kevin Littlejohn "kevin@littlejohn.id.au"
RUN apt-get -y -q update; \
  apt-get -y -q upgrade; \
  apt-get -y -q install python-software-properties; \
  add-apt-repository ppa:rquillo/ansible -y; \
  apt-get -y -q update; \
  apt-get -y -q install ansible
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
