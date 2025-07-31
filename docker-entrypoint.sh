#!/bin/sh
set -e

exec /opt/keycloak/bin/kc.sh start \
  --optimized \
  --proxy-headers=xforwarded \
  "$@"
