#!/bin/sh
set -e

# Cria o diretório SSL se não existir
mkdir -p /etc/nginx/ssl

# Gera o certificado autoassinado apenas se não existir
if [ ! -f /etc/nginx/ssl/fullchain.pem ]; then
    echo "Gerando certificado SSL autoassinado..."
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/key.pem \
        -out /etc/nginx/ssl/fullchain.pem \
        -subj "/C=PT/ST=Lisbon/L=Lisbon/O=42/OU=Student/CN=${DOMAIN_NAME}"
fi

# Substitui a variável de ambiente no ficheiro de configuração do Nginx
# Corrigido para usar a sintaxe correta da variável
echo "Configurando o Nginx..."
envsubst '${DOMAIN_NAME}' < /etc/nginx/nginx.conf > /tmp/nginx.conf && mv /tmp/nginx.conf /etc/nginx/nginx.conf

# Passa o controlo para o comando principal (o CMD do Dockerfile)
exec "$@"