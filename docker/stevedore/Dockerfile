FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

# Install pre-requisites
RUN apt-get -yq install ruby-dev
RUN apt-get -yq install make
RUN apt-get -yq install ruby1.9.3
RUN apt-get -yq install libsqlite3-dev
RUN apt-get -yq install nodejs
RUN gem install rails

# Add a Stevedore user
RUN adduser --disabled-password --gecos "" stevedore; \
  echo "stevedore ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/stevedore
USER stevedore

# Add the project to the container
ADD stevedore /opt/stevedore

# Set our base directory
WORKDIR /opt/stevedore

CMD ["rails", "server"]