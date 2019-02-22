# docker-geoserver

This project now supports creating the geoserver container
and starting all the supporting players via docker-compose.

The container is called geoceg/geoserver, which is a Docker container containing Geoserver.
Geoserver is a Java web app, so this container is built on Tomcat 9.

For complete information on Geoserver, see http://geoserver.org/

FIXME -- PASSWORD
There is a tomcat-users.xml file where you can specify a password. Edit it to change passwords.

FIXME -- NETWORK
I also put in a context.xml file with 192.168.x.x access allowed to the manager app;
by default it's only accessible from localhost. Edit it if you are not in a 192.168 network.

FIXME -- GeoWebCache gets installed and started but geoserver does not know it's there!

# Some useful commands

## Create a volume to persist settings.

    docker volume create geoserver_data

## Settings

Copy dotenv-sample to .env and then edit it to specify site-specific information including passwords and hostname.

## Run everything

This command starts nginx, postgis, geoserver, geowebcache, and pgadmin4

    docker-compose up -d

It uses the config file docker-compose.yml to set all this up.

# Master password

You probably don't care at all about access to Tomcat, but should you, here is info
on the master password it creates.

Once the container is running it will place files in the volume, which on my computer is in
/home/docker/volumes/geoserver_files/_data. It's probably under in /var/lib/docker on yours.
You can check with 'docker inspect'.

A root password will be found in masterpw.info -- on your host (not in the container),
you can do this:

````
root@bellman:/home/docker/volumes/geoserver_data/_data# cd security/
root@bellman:/home/docker/volumes/geoserver_data/_data/security# ls -ltr
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
root@bellman:/home/docker/volumes/geoserver_data/_data/security# cat masterpw.info
This file was created at 2018/05/10 04:39:12
The generated master password is: IT3~,?'7

Test the master password by logging in as user "root"

This file should be removed after reading !!!.
````
You can log into Geoserver at http://localhost:8888/geoserver
using root and that password then create your own accounts.

### Sample data issue

If you use a volume you won't be able to access the GeoServer sample
data with this container, it's in the wrong place, I used to have
complicated instructions here on how to fix this, but I don't care
about the sample data anymore. Just use your own.

## Developer commands

When I want to test a new container locally, I do this.

    docker build -t geoceg/geoserver .
 
Once I am convinced it works then I commit all changes to github and Docker
will autobuild a new version for you.
