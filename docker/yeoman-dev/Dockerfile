FROM silarsis/yeoman
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -yq update && apt-get -yq upgrade

ADD . /src
RUN cd /src; npm install
EXPOSE 9000
USER yeoman
CMD ["grunt", "serve"]