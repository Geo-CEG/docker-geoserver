#docker-geoserver

This project deploys GeoServer and GeoWebCache into 
a standard Tomcat 9 container.

NOTE that I am using the Tomcat build on Debian not Alpine,
because the geoserver-compose project adds packages using apt,
and Alpine does not support that.

I am including GeoWebCache here, I have tried several ways
to deploy it to a separate container and just can't see there is
any benefit to doing it that way. They are tightly integrated.

Latest version of GeoServer is 2.16.0

Latest version of GeoWebCache is 1.16.0

Tomcat is 9.0.26

For complete information on GeoServer, see http://www.geoserver.org/

For complete information on GeoWebCacheServer, see http://www.geoserver.org/

## Settings

I used to enable a Tomcat management account with a password but I never used it.
The container is intended to be hidden behind an nginx cache and is never
accessed directly so it does not need the Tomcat manager GUI exposed.

## Deployment

I want the war files fully deployed when the image is pushed to hub.docker.com
so that I can build a docker-compose set up and immediately add GeoServer plugins.
The folder has to exist in the image for this to happen and the only way it
gets created is when Tomcat automatically deploys the war files.

The easiest way to do that that I can think of right now is to start
the image, allow Tomcat to deploy, then stop it and push the image
manually up to Docker Hub.

Eventually I will figure out how to automate this, maybe tomorrow or next week.

The problem is that Tomcat runs as a service so there is no way I know of
to do the deployment from a Dockerfile RUN command. Once Tomcat is started,
it just runs forever. Maybe there is a Tomcat command line option??

Anyway here are the steps for now.


```
docker build -t geoserver_temporary .
```
This should exit cleanly with "Successfully tagged", not with 1000's of lines of HTML;
the version number is probably wrong in the Dockerfile for one of the zips.

```
docker run -it --name geoserver_build_container -v geoserver_data:/geoserver geoserver_temporary
```

Now wait for Tomcat to start and watch log files... you should see the WARs deploy and then the last line will resemble this.
```
07-Mar-2019 19:47:01.390 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 68970 ms
```
If it starts up fast there is probably something that did not deploy. On a small computer it takes 2 minutes.
Then stop the container (from another window) and commit a new image.

```
docker stop geoserver_build_container
docker commit geoserver_build_container geoserver_deployed
docker rm geoserver_build_container
```

When you stop the build image and commit you are creating a new image from a container.
Now you have an image called "geoserver_deployed" that has the WAR files deployed.
You can see what changed in the container with the command "docker diff geoserver" if you want.

Now you can push the image to the Hub.

```
GEOSERVER_VERSION=2.16.0

# Send the numbered version up. This will take a few minutes.
docker tag geoserver_deployed wildsong/geoserver:${GEOSERVER_VERSION}
docker push wildsong/geoserver:${GEOSERVER_VERSION}

# Send the "latest" version up, too. This will go fast. 
docker tag geoserver_deployed wildsong/geoserver:latest
docker push wildsong/geoserver:latest
```
