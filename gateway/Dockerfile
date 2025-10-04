FROM nginx:alpine

WORKDIR /etc/nginx

COPY nginx.conf /etc/nginx/nginx.conf.template
COPY ssl /etc/nginx/ssl
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN mkdir -p /var/log/nginx

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
