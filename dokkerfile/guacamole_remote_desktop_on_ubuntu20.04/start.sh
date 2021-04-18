#!/bin/bash
nohup /opt/tomcat/tomcatapp/bin/catalina.sh run &
/etc/init.d/guacd start