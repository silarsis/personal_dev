FROM silarsis/base
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
RUN echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list
RUN wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | apt-key add -
RUN apt-get -yq update && apt-get -yq install jenkins=1.553
USER jenkins
ENV HOME /var/lib/jenkins
WORKDIR /var/lib/jenkins
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]