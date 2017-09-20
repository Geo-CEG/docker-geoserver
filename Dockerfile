FROM tomcat:9-jre8
MAINTAINER Brian H Wilson "b.wilson@geo-ceg.org"

#RUN apt-get update && apt-get install wget unzip

ENV GEOSERVER_VERSION    2.11.2
ENV GEOSERVER_HOME       ${CATALINA_HOME}/webapps/geoserver
ENV GEOSERVER_DATA_DIR   ${GEOSERVER_HOME}/data
ENV GEOWEBCACHE_DATA_DIR ${GEOSERVER_HOME}/geowebcache

WORKDIR ${CATALINA_HOME}/webapps
RUN wget --progress=bar:force:noscroll -O geoserver.war.zip http://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip &&\
    unzip geoserver.war.zip &&\
    rm geoserver.war.zip

#RUN apt-get remove -y wget unzip

# Expand the memory space for Tomcat
ENV CATALINA_OPTS "-Djava.awt.headless=true -Xmx768m -Xrs -XX:PerfDataSamplingInterval=500 -Dorg.geotools.referencing.forceXY=true -DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} -DGEOWEBCACHE_DATA_DIR=${GEOWEBCACHE_DATA_DIR}"

# Where we keep our files
VOLUME ${GEOSERVER_DATA_DIR}

# possibly add this?
#HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:8080 || exit 1
