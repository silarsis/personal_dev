# Packer
FROM localhost:5000/ssh-server
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get install -yq wget ca-certificates build-essential git mercurial

ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /usr/local/go

RUN wget --no-verbose https://go.googlecode.com/files/go1.2.src.tar.gz
RUN tar -v -C /usr/local -xzf go1.2.src.tar.gz
RUN cd /usr/local/go/src && ./make.bash --no-clean 2>&1

RUN chmod go+w /tmp
RUN adduser --disabled-password --gecos "" packer; \
  echo "packer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
ENV HOME /home/silarsis
USER silarsis

RUN go get -u github.com/mitchellh/gox
RUN git clone https://github.com/mitchellh/packer.git $GOPATH/src/github.com/mitchellh/packer
RUN cd $GOPATH/src/github.com/mitchellh/packer && make

WORKDIR $HOME

CMD ["bin/bash"]