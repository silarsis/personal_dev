# Designed to be linked to a running mysql server

FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq install mysql-client
ADD run.sh /usr/local/bin/run.sh
CMD ["/usr/local/bin/run.sh"]
