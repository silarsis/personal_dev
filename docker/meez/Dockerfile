FROM ubuntu:saucy
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -yq update && apt-get -yq upgrade

RUN apt-get -yq install ruby
RUN apt-get -yq install ruby-dev
RUN apt-get -yq install make
RUN gem install rdoc # Need to do first for https://github.com/rdoc/rdoc/issues/175
RUN gem install meez

CMD ['/bin/bash']