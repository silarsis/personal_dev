FROM ubuntu:trusty
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN apt-get -yq update && apt-get -yq upgrade \
  && apt-get -yq install curl gcc make libssl-dev zlib1g-dev
# Ruby
WORKDIR /usr/local/src
RUN curl -sSL http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz | tar zx \
  && cd /usr/local/src/ruby-2.1.3 \
  && ./configure && make && make install \
  && rm -rf /usr/local/src/ruby-2.1.3
RUN gem install bundler --no-ri --no-rdoc
RUN gem install ZenTest --no-ri --no-rdoc
RUN gem install rspec-autotest --no-ri --no-rdoc
RUN addgroup gems \
  && chgrp -R gems /usr/local/lib/ruby \
  && chmod -R g+w /usr/local/lib/ruby \
  && find /usr/local/lib/ruby -type d -exec chmod g+s {} \;
VOLUME /usr/local/lib/ruby
