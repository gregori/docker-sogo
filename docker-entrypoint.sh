#!/bin/bash
set -e

sed -i "s {SOGO_SGBD} $SOGO_SGBD g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_USER} $SOGO_USER g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_PASSWD} $SOGO_PASSWD g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_DBHOST} $SOGO_DBHOST g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_DBPORT} $SOGO_DBPORT g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_DATABASE} $SOGO_DATABASE g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_IMAPSERVER} $SOGO_IMAPSERVER g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_SIEVESERVER} $SOGO_SIEVESERVER g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_SMTPSERVER} $SOGO_SMTPSERVER g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_WOPORT} $SOGO_WOPORT g" /etc/sogo/sogo.conf && \
sed -i "s {SOGO_MAILDOMAIN} $SOGO_MAILDOMAIN g" /etc/sogo/sogo.conf 


if [ "$1" = 'sogod' ]; then
	exec gosu sogo "$@"
else
	exec "$@"
fi