#!/bin/bash

# Setup

USERNAME="www-data"
GROUPNAME="www-data"

chown -R $USERNAME:$GROUPNAME /testssl/log /testssl/result/json /testssl/result/html

service nginx start && uwsgi \
    --uid $USERNAME \
    --gid $GROUPNAME \
    -s /tmp/uwsgi.sock \
    -M -p 4 \
    --plugin python3 \
    --die-on-term \
    --manage-script-name \
    --chdir /testssl \
    --python-path /testssl \
    --mount /=SSLTestPortal:application
    
