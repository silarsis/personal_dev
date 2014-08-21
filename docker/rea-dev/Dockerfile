FROM dev
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN /bin/bash -l -c "gem source -a http://rubygems.delivery.realestate.com.au/"
RUN /bin/bash -l -c "gem install rea-ec2"
RUN /bin/bash -l -c "gem install rea-aws-koolaid"

RUN apt-get install -yq groff
RUN apt-get install -yq jq
RUN apt-get install -yq curl
RUN apt-get install -yq uuid-runtime

# Local additions
ADD bash-functions /etc/profile.d/saml.sh
ADD authenticate_or_die.sh /usr/local/bin/authenticate_or_die.sh
ADD config /home/silarsis/.aws/config
RUN chmod 777 /etc/profile.d/saml.sh /usr/local/bin/authenticate_or_die.sh
