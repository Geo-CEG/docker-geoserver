# docker-geoserver

This project deploys GeoServer and GeoWebCache into 
a standard Tomcat 9 container.

NOTE that I am using the Tomcat build on Debian not Alpine,
because the geoserver-compose project adds packages using apt,
and Alpine does not support that.

I am including GeoWebCache here, I have tried several ways
to deploy it to a separate container and just can't see there is
any benefit for me in doing it that way. They are tightly integrated,
it's just easier this way. I might do it differently on a production
server.

2021-Jun-02

Define the version numbers in the Makefile.

* Latest version of GeoServer is 2.19.1
* Latest version of GeoWebCache is 1.19.1
* Tomcat is 9.0.46

For complete information on GeoServer, see http://www.geoserver.org/

For complete information on GeoWebCacheServer, see http://www.geoserver.org/

## Settings

I used to enable a Tomcat management account with a password but I never used it.
The container is intended to be hidden behind an nginx cache and is never
accessed directly so it does not need the Tomcat manager GUI exposed.

## Examples

I use this image in a Docker Compose project, where it runs geoserver, nginx, pgadmin. Currently
the PostGIS database runs on the host, not in Docker.

For Docker Compose, see [Wildsong/geoserver-compose](https://github.com/Wildsong/geoserver-compose).

To use it in a Dockerfile, refer to the Docker Compose project and look
in the file "Dockerfile.geoserver".

## Building an image for hub.docker.com

Here are the steps that I use to create the images on hub.docker.com.

**THESE INSTRUCTIONS ARE FOR ME**, all you should have to do is
```bash
   docker pull wildsong/geoserver:latest
```

### Here's the problem

I want the war files fully deployed when the image is pushed to
hub.docker.com so that I can use it in docker-compose (or other
Dockerfiles) *immediately* and add GeoServer plugins in a Dockerfile.
The geoserver folder has to exist in the image for this to happen and
the only way it gets created is when Tomcat automatically deploys the
war files.

### My solution

The easiest way to get an image with Geoserver deployed that that I
can think of right now is to start a container from the image, allow
Tomcat to deploy, then stop it and push the image manually up to
Docker Hub.

Eventually I will figure out how to automate this.

The problem is that Tomcat runs as a service so there is no way I know
of to do the deployment from a Dockerfile RUN command. Once Tomcat is
started, it just runs forever. Maybe there is a Tomcat command line
option ("deploy only, don't run")??

### Step by step, image build

I built a Makefile to make it a little easier. Step one:
```bash
    make build
```

This should exit cleanly with "Successfully tagged", not with 1000's
of lines of HTML; if you get that then the version number is probably
wrong in the Makefile for one of the zips.  Check the first two lines
of the Makefile against the archives in SourceForge.

(You can look in https://sourceforge.net/projects/geoserver/files/GeoServer/ and
https://sourceforge.net/projects/geowebcache/files/geowebcache/)

Now launch a temporary container and wait for Tomcat to start successfully; watch the log file output.

```bash
make image
```

This runs the container in foreground with output spilling out on your screen. Be patient.
You should see the WARs deploy and then the last line will resemble this:
```
07-Mar-2019 19:47:01.390 INFO [main] org.apache.catalina.startup.Catalina.start Server startup in 68970 ms
```
If it starts up fast there is probably something that did not deploy. On my small computer
it takes 2 minutes or more. Then stop the container from another window and commit a new image,
using this command.

```bash
make commit
```

"Make commit" will stop the build image and commit the container to a new image called
"geoserver_deployed", that will be an image that has the WAR files deployed.
You can see what changed in the container with the command "docker diff geoserver" if you want.

Now you can push new images to the Hub.

```bash
make push
```

After the images are pushed, the geoserver_deployed image will be
deleted.  You can now use "FROM wildsong/geoserver:latest" in a
Dockerfile and get the latest geoserver.

