FROM dev
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

RUN cd /tmp \
  && curl -OL https://github.com/coreos/fleet/releases/download/v0.8.3/fleet-v0.8.3-linux-amd64.tar.gz \
  && tar zxf fleet-v0.8.3-linux-amd64.tar.gz \
  && cd fleet-v0.8.3-linux-amd64 \
  && mv fleetctl /usr/local/bin \
  && rm -rf /tmp/fleet-*
