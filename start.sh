#!/bin/bash
set -e
source /root/.bashrc

# Copy sample data from the old location to the new persisted one.
# This does not work because the WAR has not been deployed yet.
#cp -r ${CATALINA_HOME}/webapps/geoserver/data ${GEOSERVER_DATA_DIR}

exec catalina.sh run

