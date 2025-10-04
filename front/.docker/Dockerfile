# 1. Build frontend
FROM node:alpine AS builder

ARG FRONT_PORT
ARG FRONT_API_HOST

ENV FRONT_PORT=${FRONT_PORT}
ENV FRONT_API_HOST=${FRONT_API_HOST}

WORKDIR /app

COPY . .
RUN npm ci --omit=dev && npm cache clean --force
RUN npm run build

# 2. Serve frontend with nginx
FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY --from=builder /app/dist .
COPY ./.docker/entrypoint.sh /entrypoint.sh
COPY ./.docker/nginx.conf /etc/nginx/nginx.conf.template
RUN chmod +x /entrypoint.sh

# Make it easier 🙃😇
RUN apk add --no-cache bash && echo "alias ll='ls -lah'" >> /root/.bashrc

EXPOSE ${FRONT_PORT}

ENTRYPOINT ["/entrypoint.sh"]
