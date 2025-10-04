#!/bin/sh
set -e

echo "Configuring GATEWAY nginx.conf"

sed \
  -e "s|\$GATEWAY_API_HOST|${GATEWAY_API_HOST}|g" \
  -e "s|\$GATEWAY_API_PORT|${GATEWAY_API_PORT}|g" \
  -e "s|\$GATEWAY_API_SERVER_NAME|${GATEWAY_API_SERVER_NAME}|g" \
  -e "s|\$GATEWAY_FRONT_HOST|${GATEWAY_FRONT_HOST}|g" \
  -e "s|\$GATEWAY_FRONT_PORT|${GATEWAY_FRONT_PORT}|g" \
  -e "s|\$GATEWAY_FRONT_SERVER_NAME|${GATEWAY_FRONT_SERVER_NAME}|g" \
  /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Starting GATEWAY"
nginx -g "daemon off;"
