FROM tifayuki/java:7
MAINTAINER Siwo24 <siwo@siwo24.pl>

RUN apt-get update && \
    apt-get install -yq --no-install-recommends wget pwgen ca-certificates openssh-client sshpass openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV TOMCAT_MAJOR_VERSION 7
ENV TOMCAT_MINOR_VERSION 7.0.32
ENV CATALINA_HOME /tomcat
ENV SIWO_SSH_PASSWORD tomcat
ENV SIWO_SHH_USER tomcat
ENV SIWO_IPADDRESS 127.0.0.1
ENV SIWO_PATH_TO_APP /home/tomcat
ENV SIWO_APP_DIR siwo
ENV SIWO_APP_NAME application
ENV SIWO_APP_VERSION test

# INSTALL TOMCAT
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

ADD create_tomcat_admin_user.sh /create_tomcat_admin_user.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh
RUN rm -rf ${CATALINA_HOME}/webapps/*
RUN useradd tomcat -p tomcat
RUN mkdir /home/tomcat
RUN mkdir /home/tomcat/siwo
RUN touch /home/tomcat/siwo/application##test.war
RUN chmod -R 777 /home

RUN  sshpass -p ${SIWO_SSH_PASSWORD} scp -o StrictHostKeyChecking=no ${SIWO_SHH_USER}@${SIWO_IPADDRESS}:${SIWO_PATH_TO_APP}/${SIWO_APP_DIR}/${SIWO_APP_NAME}##${SIWO_APP_VERSION}.war ${CATALINA_HOME}/webapps

RUN userdel tomcat
RUN rm -rf /home

EXPOSE 8080

CMD ["/run.sh"]