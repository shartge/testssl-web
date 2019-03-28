#!/bin/bash

set -e

export CHECKTIMEOUT=${TEST_TIMEOUT:-300}

UWSGI_READ_TIMEOUT=$(( CHECKTIMEOUT + 10))

# Replacing placeholder variables

sed -i "s/@@UWSGI_READ_TIMEOUT@@/${UWSGI_READ_TIMEOUT}/" /etc/nginx/sites-enabled/default;

exec "$@"
