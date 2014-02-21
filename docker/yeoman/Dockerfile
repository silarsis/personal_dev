FROM silarsis/yeoman
MAINTAINER Kevin Littlejohn "kevin@littlejohn.id.au"
ADD . /src
RUN cd /src; npm install
EXPOSE 9000
USER yeoman
CMD ["grunt", "serve"]