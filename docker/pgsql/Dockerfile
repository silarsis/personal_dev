FROM centos
MAINTAINER Kevin Littlejohn <kevin@littlejohn.id.au>
ENV http_proxy http://172.17.42.1:3142
RUN echo 'NETWORKING=yes' > /etc/sysconfig/network

# Install Postgresql
# First three lines match the order in the main Dockerfile, for cacheing
RUN rpm -i http://yum.postgresql.org/9.3/redhat/rhel-6-x86_64/pgdg-redhat93-9.3-1.noarch.rpm
RUN yum install -y postgresql93-devel
ENV PATH /usr/pgsql-9.3/bin:$PATH

RUN yum install -y postgresql93 postgresql93-server postgresql93-contrib
RUN service postgresql-9.3 initdb en_AU.UTF-8
RUN sed -i 's/ident/trust/g' /var/lib/pgsql/9.3/data/pg_hba.conf
RUN service postgresql-9.3 start && chkconfig postgresql-9.3 on && cd /tmp && su postgres -c "createuser -s rea-app"
USER postgres
EXPOSE 5432
CMD ["/usr/pgsql-9.3/bin/postgres", "-D", "/var/lib/pgsql/9.3/data"]
