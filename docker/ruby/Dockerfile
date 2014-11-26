FROM ubuntu:trusty
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN apt-get -yq update && apt-get -yq upgrade \
  && apt-get -yq install curl gcc make libssl-dev zlib1g-dev
# Ruby
WORKDIR /usr/local/src
RUN curl -sSL http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz | tar zx \
  && cd /usr/local/src/ruby-2.1.3 \
  && ./configure --prefix=/usr/local/ruby && make && make install \
  && rm -rf /usr/local/src/ruby-2.1.3
ENV GEM_HOME /usr/local/ruby
RUN /usr/local/ruby/bin/gem install bundler --no-ri --no-rdoc \
    && /usr/local/ruby/bin/bundle config --global jobs 4
RUN addgroup ruby \
  && chgrp -R ruby /usr/local/ruby \
  && chmod -R g+w /usr/local/ruby \
  && find /usr/local/ruby -type d -exec chmod g+s {} \;
