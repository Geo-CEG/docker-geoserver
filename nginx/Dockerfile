FROM nginx

WORKDIR /etc/nginx/

# These proxy conf files all reference other
# containers in this docker-compose.
ADD proxy.d/geoserver.conf proxy.d/
ADD proxy.d/geowebcache.conf proxy.d/
ADD proxy.d/pgadmin.conf proxy.d/

ARG virtualhost
LABEL virtualhost=${virtualhost}

ADD fullchain.pem certs/ssl_cert.pem
ADD privkey.pem certs/ssl_key.pem
ADD dhparams.pem certs/dhparams.pem

WORKDIR /etc/nginx/conf.d/
ADD virtualhost.conf.j2 /etc/nginx/conf.d/
ADD virtualhost_ssl.conf /etc/nginx/snippets/

# If I need more flexibility I can switch to using jinja2 templates
#RUN pip install j2cli

# NB that the envariable is expanded right here so
# it does not need to be passed to the container in an ENV statement.

RUN rm -f /etc/nginx/conf.d/default.conf && \
    /bin/sed "s/{{ virtualhost }}/${virtualhost}/" < virtualhost.conf.j2 > virtualhost.conf

# Possibly add this health check?
#HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD curl -S 127.0.0.1:80 || exit 1
