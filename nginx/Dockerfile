FROM nginx

WORKDIR /etc/nginx/
CMD mkdir proxy.d && mkdir certs

COPY proxy.d/geoserver.conf proxy.d/
COPY proxy.d/geowebcache.conf proxy.d/
COPY proxy.d/pgadmin4.conf proxy.d/

COPY ${SSL_CERT} certs/
COPY ${SSL_KEY} certs/
COPY ${SSL_DHPARAMS} certs/

ADD virtualhost.conf.template /etc/nginx/conf.d

WORKDIR /etc/nginx/conf.d/
CMD "sed 's/%VIRTUALHOST%/${VIRTUALHOST}/' < virtualhost.conf.template > virtualhost.conf"

RUN ["/usr/sbin/nginx -g 'daemon off'"]

# Possibly add this health check?
#HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -S 127.0.0.1:80 || exit 1
