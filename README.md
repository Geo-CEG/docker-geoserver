# docker-geoserver

This project downloads and deploys a GeoServer "war" file to
a standard Tomcat 9 container.

For complete information on GeoServer, see http://www.geoserver.org/

The project is automatically built at hub.docker.com too,
for inclusion in https://github.com/Geo-CEG/geoserver-compose

## Settings

Copy dotenv-sample to .env and then edit it to specify site-specific information including passwords and hostname.

## Master password

There will be a master password stashed away in the Tomcat containers
(for geoserver and geowebcache). I used to have information here on
how to find it, but I don't think it's that important anymore. Google it.


