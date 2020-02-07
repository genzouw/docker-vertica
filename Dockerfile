FROM centos:centos6
LABEL maintainer "genzouw <genzouw@gmail.com>"

RUN yum update -y \
    && yum install -y \
        curl \
        gdb \
        java-1.8.0-openjdk-devel \
        mcelog \
        openssh-clients \
        openssh-server \
        openssl \
        sudo \
        sysstat \
        which \
    ;

# grab gosu for easy step-down from root
RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.1/gosu' \
	&& chmod +x /usr/local/bin/gosu

ENV LANG en_US.utf8
ENV TZ "Asia/Tokyo"

RUN groupadd -r verticadba
RUN useradd -r -m -g verticadba dbadmin

COPY vertica-*.rpm /rpms/vertica.rpm

RUN yum install -y /rpms/vertica.rpm

RUN yum clean all

RUN /opt/vertica/sbin/install_vertica --license CE --accept-eula --hosts 127.0.0.1 --dba-user-password-disabled --failure-threshold NONE --no-system-configuration

USER dbadmin
RUN /opt/vertica/bin/admintools -t create_db -s localhost --skip-fs-checks -d DEFAULTDB -c /home/dbadmin/DEFAULTDB/catalog -D /home/dbadmin/DEFAULTDB/data
USER root

RUN mkdir /tmp/.python-eggs
RUN chown -R dbadmin /tmp/.python-eggs
ENV PYTHON_EGG_CACHE /tmp/.python-eggs

ENV VERTICADATA /home/dbadmin/DEFAULTDB
VOLUME  /home/dbadmin/DEFAULTDB

RUN echo 'export PATH="/opt/vertica/bin:/opt/vertica/packages/kafka/bin:$PATH"' >> /etc/bashrc

COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5433
