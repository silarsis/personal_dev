FROM ubuntu:trusty
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN apt-get -yq update && apt-get -yq upgrade \
  && apt-get -yq install autoconf bison build-essential libssl-dev libyaml-dev \
    libreadline6-dev zlib1g-dev libncurses5-dev curl git openssl

# Ruby
WORKDIR /usr/local/src
RUN git clone https://github.com/sstephenson/ruby-build.git \
  && cd ruby-build \
  && ./install.sh
RUN /usr/local/bin/ruby-build 2.1.5 /usr/local/ruby
RUN /usr/local/ruby/bin/gem install bundler --no-ri --no-rdoc \
    && /usr/local/ruby/bin/bundle config --global jobs 4
RUN addgroup ruby \
  && chgrp -R ruby /usr/local/ruby \
  && chmod -R g+w /usr/local/ruby \
  && find /usr/local/ruby -type d -exec chmod g+s {} \;
