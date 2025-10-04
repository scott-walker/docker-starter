.SILENT:
include .env

# Генерировать SSL сертификат
generate-ssl:
	mkdir -p gateway/ssl
	mkcert -key-file gateway/ssl/$(GATEWAY_API_HOST).key -cert-file gateway/ssl/$(GATEWAY_API_HOST).cert $(GATEWAY_API_HOST) 127.0.0.1 ::1
	echo "SSL сертификат создан в gateway/ssl/"

# Добавить хост в /etc/hosts
add-hosts:
	echo "\n# DockerStarter generated hosts" | sudo tee -a /etc/hosts
	echo "127.0.0.1 $(GATEWAY_API_HOST)" | sudo tee -a /etc/hosts
	echo "::1 $(GATEWAY_API_HOST)" | sudo tee -a /etc/hosts

# Собрать образ для GATEWAY
build-gateway:
	docker build -t $(PROJECT_NAME)-gateway $(PWD)/gateway

# Собрать образ для API
build-api:
	docker build -t $(PROJECT_NAME)-api $(PWD)/api

# Создать сеть
create-network:
	docker network create $(PROJECT_NAME)-network

# Запустить GATEWAY
run-gateway:
	docker run -d \
		--name gateway \
		--network $(PROJECT_NAME)-network \
		-p 80:80 \
		-p 443:443 \
		-e GATEWAY_API_HOST=$(GATEWAY_API_HOST) \
		-e GATEWAY_API_PORT=$(GATEWAY_API_PORT) \
		-e GATEWAY_API_SERVER_NAME=$(GATEWAY_API_SERVER_NAME) \
		-v $(PWD)/gateway/ssl:/etc/nginx/ssl:ro \
		-v $(PWD)/gateway/logs:/var/log/nginx \
		$(PROJECT_NAME)-gateway
	echo "GATEWAY запущен на https://$(GATEWAY_API_SERVER_NAME)"

# Запустить API
run-api:
	docker run -d \
		--name api \
		--network $(PROJECT_NAME)-network \
		-e API_PORT=$(API_PORT) \
		$(PROJECT_NAME)-api
