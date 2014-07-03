FROM novembereleven/go
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get install -yq git bzr
RUN mkdir -p /src && cd /src && git clone https://github.com/realestate-com-au/credulous.git
WORKDIR /src/credulous
RUN go get -u
CMD ['/bin/bash']
