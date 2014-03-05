FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

# Install pre-requisites
RUN apt-get -yq install ruby-dev
RUN apt-get -yq install make
RUN apt-get -yq install ruby
RUN apt-get -yq install rubygems
RUN gem install rails

# Add a Stevedore user
RUN adduser --disabled-password --gecos "" stevedore; \
  echo "stevedore ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/stevedore
USER stevedore
WORKDIR /home/stevedore

# Add the project to the container
ADD . /home/stevedore/stevedore

RUN touch /home/stevedore/test.txt

CMD ["/bin/bash"]