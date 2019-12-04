GEOSERVER_VERSION=2.16.1
GEOWEBCACHE_VERSION=1.16.1

all:	build

build: Dockerfile
	docker build -t geoserver_temporary \
	  --build-arg GEOSERVER_VERSION=${GEOSERVER_VERSION} \
	  --build-arg GEOWEBCACHE_VERSION=${GEOWEBCACHE_VERSION} \
	  .

image:
	docker run -it --name geoserver_build_container -v geoserver_data:/geoserver geoserver_temporary

commit:
	docker stop geoserver_build_container
	docker commit geoserver_build_container geoserver_deployed
	docker rm geoserver_build_container

push:
	# Send the numbered version up. This will take a few minutes.
	docker tag geoserver_deployed wildsong/geoserver:${GEOSERVER_VERSION}
	docker push wildsong/geoserver:${GEOSERVER_VERSION}
	# Send the "latest" version up, too. This will go fast. 
	docker tag geoserver_deployed wildsong/geoserver:latest
	docker push wildsong/geoserver:latest
	docker rmi geoserver_deployed
