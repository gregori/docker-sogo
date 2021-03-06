FROM debian:jessie
MAINTAINER	Rodrigo Gregori <spam@gregori.eti.br>

# Install SOGo from repository
RUN echo "deb http://inverse.ca/debian-v3 jessie jessie" > /etc/apt/sources.list.d/inverse.list && \
    apt-key adv --keyserver pool.sks-keyservers.net --recv-key FE9E84327B18FF82B0378B6719CDA6A9810273C4 && \
	echo 'Acquire::http::Proxy "http://pmj-noc01.pmjlle.joinville.sc.gov.br:3142";' > /etc/apt/apt.conf.d/10proxy && \
    apt-get update && \
    apt-get install -y --no-install-recommends sogo sope4.9-gdl1-postgresql net-tools nmap && \
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

ENV SOGO_SGBD postgresql
ENV SOGO_USER sogo
ENV SOGO_PASSWD sogopw
ENV SOGO_DBHOST db
ENV SOGO_DBPORT 5432
ENV SOGO_DATABASE sogo
ENV SOGO_IMAPSERVER imaps://imap.example.com:993
ENV SOGO_SIEVESERVER sieve.example.com
ENV SOGO_SMTPSERVER smtp.example.com
ENV SOGO_MAILDOMAIN example.com
ENV SOGO_MEMCACHED memcached
ENV SOGO_WOPORT 0.0.0.0:20000

# Interface the environment
VOLUME /srv
RUN cp -r /usr/lib/GNUstep/SOGo/ /srv

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 20000

# Baseimage init process
CMD ["sogod", "-WONoDetach", "YES", "-WOLogFile", "-"]
