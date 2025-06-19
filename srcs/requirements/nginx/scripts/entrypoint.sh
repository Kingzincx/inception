#!/bin/sh
set -e

CERT_DIR=/etc/nginx/ssl
mkdir -p "$CERT_DIR"

# gera certificado auto-assinado se não existir
if [ ! -f "$CERT_DIR/fullchain.pem" ]; then
  openssl req -x509 -nodes -days 365 \
    -newkey rsa:4096 \
    -keyout "$CERT_DIR/key.pem" \
    -out "$CERT_DIR/fullchain.pem" \
    -subj "/CN=${DOMAIN_NAME}"
fi

# substitui variáveis no template de configuração
envsubst '$DOMAIN_NAME' < /etc/nginx/nginx.conf > /tmp/nginx.conf
mv /tmp/nginx.conf /etc/nginx/nginx.conf

exec "$@"
