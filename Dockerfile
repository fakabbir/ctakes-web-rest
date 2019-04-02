from ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

ADD ./backup.sql /
ADD ./ctakes-web-rest.war /
ADD ./apache-tomcat-8.5.34.tar.gz /
ADD ./create-db.sql /
ADD ./reset-user.sql /

ADD start-tomcat.sh /start-tomcat.sh
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf
RUN chmod 644 /etc/mysql/conf.d/my.cnf
ADD supervisord-tomcat.conf /etc/supervisor/conf.d/supervisord-tomcat.conf
ADD supervisord-mysqld.conf /etc/supervisor/conf.d/supervisord-mysqld.conf

RUN rm -rf /var/lib/mysql/*

ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
ADD mysql-setup.sh /mysql-setup.sh
RUN chmod 755 /*.sh

RUN apt-get update && apt-get install -y lsb-release wget && \
  wget https://dev.mysql.com/get/mysql-apt-config_0.8.4-1_all.deb && \
  dpkg -i mysql-apt-config_0.8.4-1_all.deb && rm -f mysql-apt-config_0.8.4-1_all.deb

RUN apt-get update && \
    apt-get install -y  --allow-unauthenticated pwgen supervisor default-jre default-jdk mysql-server mysql-client libmysqlclient-dev --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password password pass' && \
#    debconf-set-selections <<< 'mysql-server-5.6 mysql-server/root_password_again password pass' && \
#    apt-get -y install mysql-server-5.6
# RUN mysql-server mysql-client --no-install-recommends
#    apt-get install tar -y
#    apt-get install -y default-jre default-jdk wget mysql-server mysql-client libmysqlclient-dev --no-install-recommends && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV TOMCAT_HOME=/opt/tomcat/apache-tomcat-8.5.34
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV CATALINA_OPTS="-Xms5120M -Xmx5120M"

WORKDIR /
RUN mkdir /opt/tomcat
#RUN tar -xf apache-tomcat-8.5.34.tar.gz --directory /opt/tomcat
RUN cp -r apache-tomcat-8.5.34 /opt/tomcat/
RUN cp ctakes-web-rest.war /opt/tomcat/apache-tomcat-8.5.34/webapps/

VOLUME  ["/etc/mysql", "/var/lib/mysql"]

WORKDIR /
#CMD /opt/tomcat/apache-tomcat-8.5.34/bin/catalina.sh run
ENTRYPOINT ./run.sh
