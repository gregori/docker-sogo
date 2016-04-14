#!/bin/bash
set -e

if [ "$1" = '/usr/sbin/sogod' ]; then
	exec gosu sogo "$@"
else
	exec "$@"
fi