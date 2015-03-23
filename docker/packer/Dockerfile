# Packer
FROM debian:jessie
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN apt-get -yq update \
    && apt-get -yq install curl ca-certificates build-essential git mercurial \
      sudo vim

ENV PATH $PATH:/usr/local/go/bin:/usr/local/gopath/bin
ENV GOPATH /usr/local/gopath

RUN curl -L https://go.googlecode.com/files/go1.2.src.tar.gz \
    | tar -v -C /usr/local -xz \
    && cd /usr/local/go/src && ./make.bash --no-clean

RUN go get -u github.com/mitchellh/gox \
    && git clone https://github.com/mitchellh/packer.git $GOPATH/src/github.com/mitchellh/packer \
    && cd $GOPATH/src/github.com/mitchellh/packer \
    && make updatedeps \
    && make dev

RUN git clone https://github.com/packer-community/packer-windows-plugins.git $GOPATH/src/github.com/packer-community/packer-windows-plugin \
    && cd $GOPATH/src/github.com/packer-community/packer-windows-plugin \
    && make dev \
    && cp bin/* /usr/local/packer

RUN chmod go+w /tmp
RUN adduser --disabled-password --gecos "" packer; \
  echo "packer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/silarsis
USER silarsis

WORKDIR $HOME

CMD ["bin/bash"]
