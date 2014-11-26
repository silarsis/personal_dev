FROM ruby
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update && apt-get -yq upgrade && apt-get -yq install patch

ADD Gemfile /usr/local/ruby/rea/Gemfile
WORKDIR /usr/local/ruby/rea
RUN chmod g+w /usr/local/ruby/rea \
  && /usr/local/ruby/bin/bundle install
VOLUME /usr/local/ruby
