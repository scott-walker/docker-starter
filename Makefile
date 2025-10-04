.SILENT:
include .env

# Генерировать SSL сертификат
generate-ssl:
	mkdir -p gateway/ssl
	mkcert -key-file gateway/ssl/${GATEWAY_API_HOST}.key -cert-file gateway/ssl/${GATEWAY_API_HOST}.cert ${GATEWAY_API_HOST} 127.0.0.1 ::1
	echo "SSL сертификат создан в gateway/ssl/"

# Собрать Docker образ
build:
	docker build -t $(PROJECT_NAME)-gateway ./gateway

# # Запустить контейнер
# run: ssl
# 	@docker run -d --name nginx-gateway -p 80:80 -p 443:443 \
# 		-v $(PWD)/gateway/ssl:/etc/nginx/ssl:ro \
# 		-e GATEWAY_API_SERVER_NAME=localhost \
# 		-e GATEWAY_API_PROXY_PASS=http://host.docker.internal:8080/ \
# 		nginx-gateway
# 	@echo "NGINX Gateway запущен на http://localhost и https://localhost"
