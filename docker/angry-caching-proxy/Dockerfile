FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>

# Install Node.js
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs

# Append to $PATH variable.
RUN echo '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bash_profile

RUN npm install -g angry-caching-proxy

EXPOSE 8080

# Define default command.
CMD ["/usr/bin/angry-caching-proxy"]
