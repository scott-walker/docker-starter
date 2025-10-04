#!/bin/sh
set -e

echo "Configuring GATEWAY nginx.conf"
sed \
  -e "s|\$FRONT_PORT|${FRONT_PORT}|g" \
  /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Replacing FRONT_API_HOST in /usr/share/nginx/html/index.js"
sed -i -e "s|\$FRONT_API_HOST|${FRONT_API_HOST}|g" /usr/share/nginx/html/index.js

echo "Starting Frontend"
nginx -g "daemon off;"
