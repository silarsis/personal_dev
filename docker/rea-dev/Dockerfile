FROM dev
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN /bin/bash -l -c "rvm all do gem source -a http://rubygems.delivery.realestate.com.au/"
RUN /bin/bash -l -c "rvm all do gem install rea-ec2"
RUN /bin/bash -l -c "rvm all do gem install rea-aws-koolaid"
RUN /bin/bash -l -c "rvm all do gem install rea-assuming"
