#!/bin/sh
set -e

# cria wp-config.php se não existir
if [ ! -f "wp-config.php" ]; then
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="$(cat ${WORDPRESS_DB_PASSWORD_FILE})" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --skip-check --quiet

    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception WP" \
        --admin_user="admin" \
        --admin_password="Admin#2025" \
        --admin_email="admin@example.com" --skip-email --quiet

    # cria conta autor
    wp user create autor autor@example.com --role=author --user_pass="Autor#2025" --quiet
fi

# garante permissões corretas
chown -R www-data:www-data /var/www/wordpress

exec "$@"
