#!/bin/bash

# Setup

GROUPNAME="www-data"
USERNAME="www-data"

chown -R $USERNAME:$GROUPNAME /testssl/log /testssl/result/json /testssl/result/html

service nginx start && uwsgi \
    --uid $USERNAME \
    -s /tmp/uwsgi.sock \
    -M -p 4 \
    --harakiri 450 \
    --plugin python3 \
    --die-on-term \
    --manage-script-name \
    --chdir /testssl \
    --python-path /testssl \
    --mount /=SSLTestPortal:application
    
