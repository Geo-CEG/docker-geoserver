FROM tomcat:9-jre8
MAINTAINER Brian H Wilson "brian@wildsong.biz"

#RUN apt-get update && apt-get install wget unzip

ENV GEOSERVER_VERSION    2.13.0
ENV GEOWEBCACHE_VERSION  1.13.0

ENV GEOSERVER_DATA_DIR   /geoserver

WORKDIR ${CATALINA_HOME}/webapps

ADD geoserver.war   geoserver.war
ADD geowebcache.war geowebcache.war

WORKDIR ${CATALINA_HOME}

# Expand the memory space for Tomcat
ENV CATALINA_OPTS "-Djava.awt.headless=true -Xmx768m -Xrs -XX:PerfDataSamplingInterval=500 -Dorg.geotools.referencing.forceXY=true -DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR}"
