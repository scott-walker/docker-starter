.SILENT:
include .env

# Docker compose up
up: 
	docker compose up -d --build

# Docker compose down
down: 
	docker compose down --remove-orphans

# Generate SSL certificate
generate-ssl:
	mkdir -p gateway/ssl
	mkcert -key-file gateway/ssl/$(GATEWAY_FRONT_SERVER_NAME).key -cert-file gateway/ssl/$(GATEWAY_FRONT_SERVER_NAME).cert $(GATEWAY_FRONT_SERVER_NAME) 127.0.0.1 ::1
	mkcert -key-file gateway/ssl/$(GATEWAY_API_SERVER_NAME).key -cert-file gateway/ssl/$(GATEWAY_API_SERVER_NAME).cert $(GATEWAY_API_SERVER_NAME) 127.0.0.1 ::1
	echo "SSL certificate created in gateway/ssl/"

# Add host to /etc/hosts
add-hosts:
	echo "\n# DockerStarter generated hosts" | sudo tee -a /etc/hosts
	echo "127.0.0.1 ${GATEWAY_FRONT_SERVER_NAME} $(GATEWAY_API_SERVER_NAME)" | sudo tee -a /etc/hosts
	echo "::1 ${GATEWAY_FRONT_SERVER_NAME} $(GATEWAY_API_SERVER_NAME)" | sudo tee -a /etc/hosts

# Build GATEWAY image
build-gateway:
	docker build \
		-t $(PROJECT_NAME)-gateway \
		-f $(PWD)/gateway/.docker/Dockerfile \
		./gateway

# Build API image
build-api:
	docker build -t \
		$(PROJECT_NAME)-api \
		-f $(PWD)/api/.docker/Dockerfile \
		./api

# Build FRONT image
build-front:
	docker build \
		-t $(PROJECT_NAME)-front \
		-f $(PWD)/front/.docker/Dockerfile \
		--build-arg FRONT_PORT=$(FRONT_PORT) \
		--build-arg FRONT_API_HOST=$(FRONT_API_HOST) \
		./front

# Create network
create-network:
	docker network create $(PROJECT_NAME)-network

# Run GATEWAY
run-gateway:
	docker run -d \
		--name $(PROJECT_NAME)-gateway \
		--network $(PROJECT_NAME)-network \
		-p 80:80 \
		-p 443:443 \
		-e GATEWAY_API_HOST=$(GATEWAY_API_HOST) \
		-e GATEWAY_API_PORT=$(GATEWAY_API_PORT) \
		-e GATEWAY_API_SERVER_NAME=$(GATEWAY_API_SERVER_NAME) \
		-e GATEWAY_FRONT_HOST=$(GATEWAY_FRONT_HOST) \
		-e GATEWAY_FRONT_PORT=$(GATEWAY_FRONT_PORT) \
		-e GATEWAY_FRONT_SERVER_NAME=$(GATEWAY_FRONT_SERVER_NAME) \
		-v $(PWD)/gateway/ssl:/etc/nginx/ssl:ro \
		-v $(PWD)/gateway/logs:/var/log/nginx \
		$(PROJECT_NAME)-gateway
	echo "API running on https://$(GATEWAY_API_SERVER_NAME)"
	echo "FRONT running on https://$(GATEWAY_FRONT_SERVER_NAME)"

# Run API
run-api:
	docker run -d \
		--name $(PROJECT_NAME)-api \
		--network $(PROJECT_NAME)-network \
		-e API_PORT=$(API_PORT) \
		$(PROJECT_NAME)-api

# Run FRONT
run-front:
	docker run -d \
		--name $(PROJECT_NAME)-front \
		--network $(PROJECT_NAME)-network \
		-e FRONT_PORT=$(FRONT_PORT) \
		-e FRONT_API_HOST=$(FRONT_API_HOST) \
		$(PROJECT_NAME)-front

# Build all
build: build-gateway build-api build-front

# Start all	
start: create-network run-api run-front run-gateway

# Stop all
stop:
	docker stop $(PROJECT_NAME)-gateway $(PROJECT_NAME)-api $(PROJECT_NAME)-front
	docker rm $(PROJECT_NAME)-gateway $(PROJECT_NAME)-api $(PROJECT_NAME)-front
	docker network rm $(PROJECT_NAME)-network

# Restart all
restart: stop start
