#!/bin/bash

set -e

USERNAME="www-data"
GROUPNAME="www-data"

chown -R $USERNAME:$GROUPNAME /testssl/output

exec "$@"
