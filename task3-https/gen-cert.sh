#!/bin/bash
# gen-cert.sh — скрипт генерации самоподписанного сертификата
# Запуск: bash gen-cert.sh
# Результат: создаёт файлы traefik/certs/cert.crt и traefik/certs/cert.key

# Получаем FQDN компьютера
# hostname -f возвращает полное доменное имя, например: mypc.local
FQDN=$(hostname -f)

echo "Ваш FQDN: $FQDN"
echo "Генерируем сертификат для: $FQDN и localhost"

# Создаём папку для сертификатов (если не существует)
mkdir -p traefik/certs

# Генерируем самоподписанный сертификат с помощью openssl:
# -x509          — создать сертификат (не запрос на подпись)
# -nodes         — не шифровать приватный ключ паролем
# -days 365      — срок действия 365 дней
# -newkey rsa:2048 — создать новый RSA-ключ длиной 2048 бит
# -keyout        — куда сохранить приватный ключ
# -out           — куда сохранить сертификат
# -subj          — subject (кому выдан сертификат)
# -addext        — дополнительные поля (SAN = Subject Alternative Names)
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout traefik/certs/cert.key \
  -out traefik/certs/cert.crt \
  -subj "/CN=${FQDN}" \
  -addext "subjectAltName=DNS:${FQDN},DNS:localhost,IP:127.0.0.1"

echo ""
echo "Готово! Созданы файлы:"
echo "  traefik/certs/cert.crt  — сертификат"
echo "  traefik/certs/cert.key  — приватный ключ"
echo ""
echo "Теперь запустите: docker compose up -d"