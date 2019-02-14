# docker-geoserver
Builds geoceg/geoserver, which is a Docker container containing Geoserver and Geowebcache.

Geoserver is a Java web app, so this container is built on Tomcat 9.

For complete information on Geoserver, see http://geoserver.org/
For information on Geowebcache, see http://geowebcache.org/

Some might argue that I have two services running in one Docker
container (Geoserver and Geowebcache) and that's bad form. Okay, point
taken. It works for me this way though. It's really easy to split them
apart into two containers by copying this Dockerfile. I've done it.

There is a tomcat-users.xml file where you can specify a password. Edit it to change passwords.
I also put in a context.xml file with 192.168.x.x access allowed to the manager app;
by default it's only accessible from localhost. Edit it if you are not in a 192.168 network.

# Some useful commands

## Build and tag (-t) as geoceg/geoserver

## Create a volume to persist settings, Storage for geowebcache is in the /geoserver/gwc subdirectory.

   docker volume create geoserver_files
 
# Run, with output to terminal (-t) or detached (-d)

With these startup commands, the URL for me will be http://bellman.wildsong.biz:8888/geoserver on my private network

Terminal mode, initial tests

    docker run -t -p 8888:8080 --name=geoserver -v geoserver_files:/geoserver geoceg/geoserver

Normal mode

    docker run -d -p 8888:8080 --name=geoserver -v geoserver_files:/geoserver geoceg/geoserver

## Shell access (once you do one of the previous commands to start an instance.)

    docker exec -it geoserver /bin/bash

## Master password

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

### Data issue

Geoserver will not deploy if webapps/geoserver/ already exists, so I can't mount a volume there.
But once geoserver deploys and starts running, it will honor the ENV setting and use the new data directory.
I have not figured out a good way to get the demo data copied from the old data directory to the volume automatically,
so I start the container and do a 'cp' command, clumsy but effective. The commands:
````bash
docker exec -it geoserver bash
cd ${CATALINA_HOME}/webapps/geoserver/data
cp -r * /srv/geoserver/data
````
Then I have to go to the geoserver status page (logged in as 'admin') and click the reload button.
After reloading I can see the demo data. This gets me far enough to step over to the PostGIS side
of things.

## Developer commands

Build a new container to test it locally

   docker build -t geoceg/geoserver .
 
Once you're convinced it works commit all changes to github and Docker should autobuild a new version.


