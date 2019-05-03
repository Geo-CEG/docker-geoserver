FROM tomcat:9-jre11
MAINTAINER Brian H Wilson "brian@wildsong.biz"

ENV GEOSERVER_VERSION 2.15.1
ENV GEOWEBCACHE_VERSION 1.15.1

ENV GEOSERVER_DATA_DIR /geoserver
ENV GEOWEBCACHE_DATA_DIR /geoserver/gwc

# Expand the memory space for Tomcat
ENV CATALINA_OPTS "-Djava.awt.headless=true -Xmx768m -Xrs -XX:PerfDataSamplingInterval=500 -Dorg.geotools.referencing.forceXY=true -DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR}"

ADD https://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip/download /tmp/geoserver.war.zip

ADD https://sourceforge.net/projects/geowebcache/files/geowebcache/${GEOWEBCACHE_VERSION}/geowebcache-${GEOWEBCACHE_VERSION}-war.zip/download /tmp/geowebcache.war.zip

WORKDIR ${CATALINA_HOME}/webapps

RUN rm -f geoserver geowebcache &&\
    unzip /tmp/geoserver.war.zip geoserver.war &&\
    unzip /tmp/geowebcache.war.zip geowebcache.war &&\
    rm /tmp/geoserver.war.zip /tmp/geowebcache.war.zip

# These folders have to exist for the deployment to be happy.
RUN mkdir ${GEOSERVER_DATA_DIR} && mkdir ${GEOWEBCACHE_DATA_DIR}
VOLUME ${GEOSERVER_DATA_DIR}

# When the container launches it starts Tomcat, which will deploy the WAR files.

WORKDIR ${CATALINA_HOME}
