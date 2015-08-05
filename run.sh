#!/bin/bash

if [ ! -f /.tomcat_admin_created ]; then
    /create_tomcat_admin_user.sh
fi

rm -rf ${CATALINA_HOME}/webapps/*

exec ${CATALINA_HOME}/bin/catalina.sh run
