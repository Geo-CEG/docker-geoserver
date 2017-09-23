FROM tomcat:9-jre8
MAINTAINER Brian H Wilson "b.wilson@geo-ceg.org"

#RUN apt-get update && apt-get install wget unzip

ENV GEOSERVER_VERSION    2.11.2
ENV GEOSERVER_HOME       ${CATALINA_HOME}/webapps/geoserver
ENV GEOSERVER_DATA_DIR   /srv/geoserver/data
#ENV GEOWEBCACHE_DATA_DIR ${GEOSERVER_HOME}/geowebcache
# Expand the memory space for Tomcat
ENV CATALINA_OPTS "-Djava.awt.headless=true -Xmx768m -Xrs -XX:PerfDataSamplingInterval=500 -Dorg.geotools.referencing.forceXY=true -DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR} -DGEOWEBCACHE_DATA_DIR=${GEOWEBCACHE_DATA_DIR}"

# Q. If I define GEOSERVER_DATA_DIR, will the sample data get deployed to the new location or the old?
# A. It's deployed to the old location
#
# Q. Will geoserver look for data in the new location?
# A. The new one.
#
# Q, accounts and authentication??

RUN mkdir -p ${GEOSERVER_DATA_DIR}

WORKDIR ${CATALINA_HOME}/webapps
RUN rm -f geoserver &&\
    wget --progress=bar:force:noscroll -O geoserver.war.zip http://downloads.sourceforge.net/project/geoserver/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip &&\
    unzip geoserver.war.zip &&\
    rm geoserver.war.zip

# So far we just need Tomcat to start normally here so this is not needed.
#RUN mkdir ${CATALINA_HOME}/tmp
#WORKDIR ${CATALINA_HOME}/tmp
#ADD start.sh ${CATALINA_HOME}/tmp
#CMD ["./start.sh"]

# possibly add this?
#HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:8080 || exit 1
