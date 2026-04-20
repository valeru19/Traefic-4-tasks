
#!/bin/bash

# Останавливаем старые контейнеры если есть
docker stop nginx-backend traefik 2>/dev/null
docker rm nginx-backend traefik 2>/dev/null

# Запускаем nginx
docker run -d --name nginx-backend -p 81:80 nginx:latest

# Получаем IP nginx автоматически
NGINX_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-backend)

# Подставляем IP в конфиг
sed -i "s|url: \"http://.*:80\"|url: \"http://${NGINX_IP}:80\"|" fileprovider/services.yml

echo "nginx IP: ${NGINX_IP}"

# Запускаем Traefik
docker run -d --name traefik \
  -p 80:80 \
  -v ~/Traefic/task1-terminal/traefik.yml:/etc/traefik/traefik.yml \
  -v ~/Traefic/task1-terminal/fileprovider:/etc/traefik/fileprovider \
  traefik:v3.3

sleep 2

# Тест
echo "--- Тест nginx напрямую (порт 81) ---"
curl -s -o /dev/null -w "%{http_code}" http://localhost:81

echo ""
echo "--- Тест через Traefik (порт 80) ---"
curl -s -o /dev/null -w "%{http_code}" http://localhost:80
echo ""
