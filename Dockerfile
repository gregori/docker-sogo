FROM debian:jessie
MAINTAINER	Rodrigo Gregori <spam@gregori.eti.br>

# Install SOGo from repository
RUN echo "deb http://inverse.ca/debian-v3 jessie jessie" > /etc/apt/sources.list.d/inverse.list && \
    apt-key adv --keyserver pool.sks-keyservers.net --recv-key FE9E84327B18FF82B0378B6719CDA6A9810273C4 && \
    apt-get update && \
    apt-get install -y --no-install-recommends sogo sope4.9-gdl1-postgresql && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install gosu
ENV GOSU_VERSION 1.7
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/* \
     && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
     && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
     && export GNUPGHOME="$(mktemp -d)" \
     && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
     && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
     && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
     && chmod +x /usr/local/bin/gosu \
     && gosu nobody true \
     && apt-get purge -y --auto-remove wget	

# Configuracao
COPY sogo.conf /etc/sogo	

# Activate required Apache modules
# RUN a2enmod headers proxy proxy_http rewrite ssl

# Move SOGo's data directory to /srv
# RUN usermod --home /srv/lib/sogo sogo

# Fix memcached not listening on IPv6
# RUN sed -i -e 's/^-l.*/-l localhost/' /etc/memcached.conf

# SOGo daemons
# RUN mkdir /etc/service/sogod /etc/service/apache2 /etc/service/memcached
# ADD sogod.sh /etc/service/sogod/run
# ADD apache2.sh /etc/service/apache2/run
# ADD memcached.sh /etc/service/memcached/run

# Make GATEWAY host available, control memcached startup
# RUN mkdir -p /etc/my_init.d
# ADD gateway.sh memcached-control.sh /etc/my_init.d/

# Interface the environment
VOLUME /srv
RUN cp -r /usr/lib/GNUstep/SOGo/ /srv

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80 443

#USER sogo
# Baseimage init process
CMD ["/usr/sbin/sogod", "-WONoDetach YES", "-WOLogFile -"]
#CMD ["ls", "-l", "/docker-entrypoint.sh"]
#ENTRYPOINT ["gosu", "sogo", "/usr/sbin/sogod", "-WONoDetach YES", "-WOLogFile -"]
# ENTRYPOINT ["cat", "/etc/sogo/sogo.conf"]
