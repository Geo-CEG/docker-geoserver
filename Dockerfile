FROM tomcat:8-jre8
MAINTAINER Brian H Wilson "brian@wildsong.biz"

#RUN apt-get update && apt-get install wget unzip


ENV GEOSERVER_URL   https://sourceforge.net/projects/geoserver/files/GeoServer/2.13.2/geoserver-2.13.2-war.zip/download
ENV GEOWEBCACHE_URL https://sourceforge.net/projects/geowebcache/files/geowebcache/1.13.2/geowebcache-1.13.2-war.zip/download
ENV GEOGIG_URL      https://github.com/locationtech/geogig/releases/download/v1.2.0-RC1/geoserver-2.13-SNAPSHOT-geogig-plugin.zip

ENV GEOSERVER_DATA_DIR   /geoserver
RUN mkdir -p ${GEOSERVER_DATA_DIR}

WORKDIR ${CATALINA_HOME}/webapps

RUN rm -f geoserver &&\
    wget --progress=bar:force:noscroll -O geoserver.war.zip ${GEOSERVER_URL} &&\
    unzip geoserver.war.zip &&\
    rm geoserver.war.zip && rm -f LICENSE.txt && rm -f README.md

RUN rm -f geowebcache &&\
    wget --progress=bar:force:noscroll -O geowebcache.war.zip ${GEOWEBCACHE_URL} &&\
    unzip geowebcache.war.zip &&\
    rm geowebcache.war.zip  && rm -f LICENSE.txt && rm -f README.md

#WORKDIR ${CATALINA_HOME}/webapps/geoserver/WEB-INF/lib
# Geogig not working yet.
#RUN rm -f geogig &&\
#    wget --progress=bar:force:noscroll -O geogig.zip ${GEOGIG_URL} &&\
#    unzip geogig.zip &&\
#    rm geogig.zip

WORKDIR ${CATALINA_HOME}

# Expand the memory space for Tomcat
ENV CATALINA_OPTS "-Djava.awt.headless=true -Xmx768m -Xrs -XX:PerfDataSamplingInterval=500 -Dorg.geotools.referencing.forceXY=true -DGEOSERVER_DATA_DIR=${GEOSERVER_DATA_DIR}"

# Allow Tomcat "manager" access from my network 
ADD manager-context.xml ${CATALINA_HOME}/webapps/manager/META-INF/

# Add password file
ADD tomcat-users.xml ${CATALINA_HOME}/conf

# Q. If I define GEOSERVER_DATA_DIR, will the sample data get deployed to the new location or the old?
# A. No, it's deployed to the old location. 
#
# Q. Will geoserver look for data in the new location?
# A. The new one.
#
# Q. accounts and authentication??


# So far we just need Tomcat to start normally here so this is not needed.
#RUN mkdir ${CATALINA_HOME}/tmp
#WORKDIR ${CATALINA_HOME}/tmp
#ADD start.sh ${CATALINA_HOME}/tmp
#CMD ["./start.sh"]

# Possibly add this health check?
#HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -sS 127.0.0.1:8080 || exit 1
