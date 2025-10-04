FROM nginx:alpine

WORKDIR /etc/nginx

COPY ./.docker/nginx.conf /etc/nginx/nginx.conf.template
COPY ./.docker/entrypoint.sh /entrypoint.sh
COPY ssl /etc/nginx/ssl

RUN chmod +x /entrypoint.sh
RUN mkdir -p /var/log/nginx

# Make it easier 🙃😇
RUN apk add --no-cache bash && echo "alias ll='ls -lah'" >> /root/.bashrc

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
