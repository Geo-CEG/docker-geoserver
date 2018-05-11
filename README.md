# docker-geoserver
Builds geoceg/geoserver, which is a Docker container containing Geoserver, Geowebcache and Tomcat.

At Geo-CEG, we use Geoserver primarily as a front end for PostGIS.
Geoserver is a Java web app, so this container is built on Tomcat 9.

For complete information on Geoserver, see http://geoserver.org/
For information on Geowebcache, see http://geowebcache.org/

Some might argue that I have two services running in one Docker container and that's
bad form. Okay, point taken. It works for me this way though. It's really easy to split them
apart into two containers by copying this Dockerfile. I've done it.

I got tired of wrestling with sourceforge.net inside the Docker file
(with "RUN wget") At the moment, geoserver release is
2.13.0. Geowebcache is at release 1.13.0, To update them, download new
files and edit the Dockerfile. Here are the download commands.

wget --progress=bar:force:noscroll -O geoserver.war.zip https://sourceforge.net/projects/geoserver/files/geoserver/2.13.0/geoserver-2.13.0-war.zip/download
unzip geoserver.war.zip

wget --progress=bar:force:noscroll -O geowebcache.war.zip https://sourceforge.net/projects/geowebcache/files/geowebcache/1.13.0/geowebcache-1.13.0-war.zip/download
unzip geowebcache.war.zip

# Some useful commands

## Build and tag (-t) as geoceg/geoserver
 docker build -t geoceg/geoserver .

## Create a volume to persist settings, Storage for geowebcache is in the /geoserver/gwc subdirectory.

 docker volume create geoserver_files
 
 # Run, with output to terminal (-t) or detached (-d)
 # URL will be http://bellman.wildsong.biz:8888/geoserver or something like it
 docker run -t -p 8888:8080 --name=geoserver -v geoserver_files:/geoserver geoceg/geoserver
 docker run -d -p 8888:8080 --name=geoserver -v geoserver_files:/geoserver geoceg/geoserver

## Shell access
 docker exec -it geoserver /bin/bash

## Push to docker hub
 docker push geoceg/geoserver

# Master password

Once the container is running it will place files in the volume, which on my computer is in
/home/docker/volumes/geoserver_files/_data. It's probably under in /var/lib/docker on yours.

A root password will be found in masterpw.info --

root@bellman:/home/docker/volumes/geoserver_files/_data# cd security/
root@bellman:/home/docker/volumes/geoserver_files/_data/security# ls -ltr
total 28
drwxr-x--- 1 root root   14 May  9 21:39 masterpw
-rw-r----- 1 root root  192 May  9 21:39 masterpw.info
-rw-r----- 1 root root   73 May  9 21:39 masterpw.xml
-rw-r----- 1 root root 1031 May  9 21:39 geoserver.jceks
drwxr-x--- 1 root root   26 May  9 21:39 pwpolicy
drwxr-x--- 1 root root   14 May  9 21:39 usergroup
drwxr-x--- 1 root root   14 May  9 21:39 role
drwxr-x--- 1 root root   14 May  9 21:39 auth
-rw-r----- 1 root root  437 May  9 21:39 services.properties
drwxr-x--- 1 root root  228 May  9 21:39 filter
-rw-r----- 1 root root 2625 May  9 21:39 config.xml
-rw-r----- 1 root root  119 May  9 21:39 version.properties
-rw-r----- 1 root root   72 May  9 21:40 masterpw.digest
root@bellman:/home/docker/volumes/geoserver_files/_data/security# cat masterpw.info
This file was created at 2018/05/10 04:39:12

The generated master password is: IT3~,?'7

Test the master password by logging in as user "root"

This file should be removed after reading !!!.

You can log into Geoserver at http://localhost:8888/geoserver
using root and that password then create your own accounts.

