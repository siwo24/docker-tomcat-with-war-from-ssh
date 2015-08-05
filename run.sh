#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

rm -rf ${CATALINA_HOME}/webapps/*

 sshpass -p ${SIWO_SSH_PASSWORD} scp -P ${SIWO_APP_SSH_PORT} -o StrictHostKeyChecking=no ${SIWO_SSH_USER}@${SIWO_IPADDRESS}:${SIWO_PATH_TO_APP}/${SIWO_APP_DIR}/${SIWO_APP_NAME}##${SIWO_APP_VERSION}.war ${CATALINA_HOME}/webapps

exec ${CATALINA_HOME}/bin/catalina.sh run
