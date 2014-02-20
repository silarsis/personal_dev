# Nodejs server with generator-webapp
FROM localhost:5000/nodejs
MAINTAINER Kevin Littlejohn "kevin@littlejohn.id.au"
# Add our ssh key
RUN adduser --disabled-password --gecos "" yeoman
ADD id_rsa.pub /home/yeoman/.ssh/authorized_keys
RUN chmod 400 /home/yeoman/.ssh/authorized_keys \
  && chown yeoman.yeoman /home/yeoman/.ssh/authorized_keys \
  && chmod u+s /usr/bin/sudo
RUN apt-get -y install git; \
  npm install yo -g; \
  npm install generator-webapp -g
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
