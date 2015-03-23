# Packer
FROM debian:jessie
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update \
    && apt-get -yq install curl ca-certificates build-essential git mercurial

ENV PATH $PATH:/usr/local/go/bin:/usr/local/gopath/bin
ENV GOPATH /usr/local/gopath

RUN curl -L https://go.googlecode.com/files/go1.2.src.tar.gz \
    | tar -v -C /usr/local -xz \
    && cd /usr/local/go/src && ./make.bash --no-clean

RUN mkdir -p /usr/local/packer
RUN go get -u github.com/mitchellh/gox

RUN git clone https://github.com/mitchellh/packer.git $GOPATH/src/github.com/mitchellh/packer \
    && cd $GOPATH/src/github.com/mitchellh/packer \
    && make updatedeps \
    && make dev \
    && mkdir -p /usr/local/packer \
    && cp bin/* /usr/local/packer \
    && rm -rf $GOPATH/src

RUN git clone https://github.com/packer-community/packer-windows-plugins.git $GOPATH/src/github.com/packer-community/packer-windows-plugin
RUN cd $GOPATH/src/github.com/packer-community/packer-windows-plugin \
    && make updatedeps \
    && make dev \
    && cp bin/* /usr/local/packer \
    && rm -rf $GOPATH/src

RUN chmod go+w /tmp
RUN adduser --disabled-password --gecos "" packer; \
  echo "packer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/packer
USER packer

WORKDIR $HOME

ADD packer.json /home/packer/packer.json
ADD amz.userdata /home/packer/amz.userdata

CMD ["bin/bash"]
