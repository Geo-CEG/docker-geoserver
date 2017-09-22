# docker-geoserver
Builds geoceg/geoserver, which is a Docker container containing Geoserver and Tomcat.

At Geo-CEG, we use Geoserver primarily as a front end for PostGIS.
Geoserver is a Java web app, so this container is built on Tomcat 9.

For complete information on Geoserver, see http://geoserver.org/

At the moment, geoserver release is 2.11.2.
To update it, edit the Dockerfile.

# Some useful commands

## Build and tag (-t) as geoceg/geoserver
docker build -t geoceg/geoserver .

## Run, with output to terminal (-t) or detached (-d)
````bash
docker run -t -p 8080:8080 --name=geoserver geoceg/geoserver
docker run -d -p 8080:8080 --name=geoserver geoceg/geoserver
````

Persist the data in a volume.
````bash
docker run -d -p 8080:8080 --name=geoserver -v /home/geoserver/data:/srv/geoserver/data geoceg/geoserver
````
I have not figured out a good way to get the demo data copied to the volume automatically, so I start the container
and do a 'cp' command, clumsy but effective. The commands:
````bash
docker exec -it geoserver bash
cd ${CATALINA_HOME}/webapps/geoserver/data
cp -r * /srv/geoserver/data
````
Then I have to go to the geoserver status page (logged in as 'admin') and click the reload button.
After reloading I can see the demo data. This gets me far enough to step over to the PostGIS side
of things.

## Shell access
docker exec -it geoserver /bin/bash


