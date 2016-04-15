#!/bin/bash
set -e

if [ "$1" = 'sogod' ]; then
	exec gosu sogo "$@"
else
	exec "$@"
fi