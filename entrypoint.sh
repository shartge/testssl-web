#!/bin/bash

set -e

USERNAME="uwsgi"
GROUPNAME="uwsgi"

LUID=${LOCAL_UID:-0}
LGID=${LOCAL_GID:-0}

export CHECKTIMEOUT=${TEST_TIMEOUT:-300}

UWSGI_READ_TIMEOUT=$(( CHECKTIMEOUT + 10))

# Step down from host root to well-known nobody/nogroup user

if [ $LUID -eq 0 ]
then
    LUID=65534
fi
if [ $LGID -eq 0 ]
then
    LGID=65534
fi

# Create user and group

groupadd -o -g $LGID $GROUPNAME >/dev/null 2>&1 ||
groupmod -o -g $LGID $GROUPNAME >/dev/null 2>&1
useradd -o -u $LUID -g $GROUPNAME -s /bin/false $USERNAME >/dev/null 2>&1 ||
usermod -o -u $LUID -g $GROUPNAME -s /bin/false $USERNAME >/dev/null 2>&1
mkhomedir_helper $USERNAME

chown -R $USERNAME:$GROUPNAME /testssl/output

# Replacing placeholder variables

sed -i "s/@@UWSGI_READ_TIMEOUT@@/${UWSGI_READ_TIMEOUT}/" /etc/nginx/sites-enabled/default;

exec "$@"
