# Designed to be linked to a running mysql server

FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq install mysql-client
ADD run_client.sh /usr/local/bin/run_client.sh
CMD ["/usr/local/bin/run_client.sh"]
