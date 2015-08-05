#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

rm -rf ${CATALINA_HOME}/webapps/*
sshpass -p 'Bartolomeo840201' scp -o StrictHostKeyChecking=no root@backup.siwo.org.pl:/opt/deploy/siwo/${SIWO_APP}/ROOT##${SIWO_VERSION}.war ${CATALINA_HOME}/webapps


exec ${CATALINA_HOME}/bin/catalina.sh run