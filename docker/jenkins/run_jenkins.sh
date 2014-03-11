#!/bin/bash
#
# Run jenkins, do some automatic updating if required, install some plugins

java -jar /usr/share/jenkins/jenkins.war &
exec /bin/bash