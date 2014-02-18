# Instructions from http://www.alexjf.net/blog/distributed-systems/hadoop-yarn-installation-definitive-guide

FROM ubuntu:quantal
MAINTAINER Kevin Littlejohn, kevin@littlejohn.id.au
RUN apt-get -y -q update; \
apt-get upgrade -y; \
apt-get -y -q install openjdk-7-jdk

RUN mkdir -p /opt/hadoop; \
cd /opt/hadoop; \
wget http://apache.mirrors.spacedump.net/hadoop/common/stable/hadoop-2.2.0.tar.gz; \
tar xvf hadoop-2.2.0.tar.gz --gzip; \
rm hadoop-2.2.0.tar.gz

ENV HADOOP_PREFIX /opt/hadoop/hadoop-2.2.0
ENV HADOOP_HOME /opt/hadoop/hadoop-2.2.0
ENV HADOOP_COMMON_HOME /opt/hadoop/hadoop-2.2.0
ENV HADOOP_CONF_DIR /opt/hadoop/hadoop-2.2.0/etc/hadoop
ENV HADOOP_HDFS_HOME /opt/hadoop/hadoop-2.2.0
ENV HADOOP_MAPRED_HOME /opt/hadoop/hadoop-2.2.0
ENV HADOOP_YARN_HOME /opt/hadoop/hadoop-2.2.0