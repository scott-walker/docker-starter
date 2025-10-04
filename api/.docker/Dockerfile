FROM node:alpine

ARG API_PORT
ENV API_PORT=${API_PORT}

WORKDIR /app

COPY . .
RUN npm ci --omit=dev && npm cache clean --force

COPY ./.docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Make it easier 🙃😇
RUN apk add --no-cache bash && echo "alias ll='ls -lah'" >> /root/.bashrc

EXPOSE ${API_PORT}

ENTRYPOINT ["/entrypoint.sh"]
