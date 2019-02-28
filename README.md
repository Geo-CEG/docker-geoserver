# docker-geoserver

This project uses docker-compose to orchestrate creation and startup of its containers.

For complete information on Geoserver, see http://geoserver.org/

# What runs here

* geoserver to serve data in a variety of formats
* geowebcache to cache map tiles
* postgis/postgresql to store data
* pgadmin to administer postgresql
* nginx to act as a proxy and also it can serve static content

## Settings

Copy dotenv-sample to .env and then edit it to specify site-specific information including passwords and hostname.

You have to copy your SSL certificates into the nginx/ directory.
I tried 47 different ways to read them in from environment settings and gave up.
The ones I am using are created by certbot and live here:

````
/etc/letsencrypt/live/maps.wildsong.biz/fullchain.pem
/etc/letsencrypt/live/maps.wildsong.biz/privkey.pem
/etc/ssl/dhparams.pem
````

## Run everything

This command starts nginx, postgis, geoserver, geowebcache, and pgadmin4

    docker-compose up -d

It uses the config file docker-compose.yml to set all this up.

## Master password

There will be a master password stashed away in the Tomcat containers
(for geoserver and geowebcache). I used to have information here on
how to find it, but I don't think it's that important anymore. Google
it.

## Sample GeoServer data issue 

If you use a volume you won't be able to access the GeoServer sample
data with this container, it's in the wrong place, I used to have
complicated instructions here on how to fix this, but I don't care
about the sample data anymore. Just use your own.

