#!/bin/sh
set -e

if [ -z "${WP_ADMIN_PASSWORD_FILE}" ] || [ ! -f "${WP_ADMIN_PASSWORD_FILE}" ]; then
    echo "WP_ADMIN_PASSWORD_FILE not set or file missing" >&2
    exit 1
fi

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
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="$(cat ${WP_ADMIN_PASSWORD_FILE})" \
        --admin_email="${WP_ADMIN_EMAIL}" --skip-email --quiet

    if [ -n "${WP_AUTHOR_USER}" ] && [ -n "${WP_AUTHOR_PASSWORD_FILE}" ] && [ -n "${WP_AUTHOR_EMAIL}" ]; then
        wp user create "${WP_AUTHOR_USER}" "${WP_AUTHOR_EMAIL}" --role=author --user_pass="$(cat ${WP_AUTHOR_PASSWORD_FILE})" --quiet
    fi
fi

# garante permissões corretas
chown -R www-data:www-data /var/www/wordpress

exec "$@"
