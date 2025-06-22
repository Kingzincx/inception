#!/bin/sh
set -e

# Adicionado: Espera pela base de dados
# Este loop garante que o script só continua quando o MariaDB estiver pronto.
echo "Aguardando o MariaDB iniciar..."
while ! mariadb -h "${WORDPRESS_DB_HOST}" -u "${WORDPRESS_DB_USER}" -p"$(cat ${WORDPRESS_DB_PASSWORD_FILE})" --silent; do
    sleep 1
done
echo "MariaDB iniciado com sucesso."

if [ ! -f "wp-config.php" ]; then
    echo "Configurando o WordPress..."

    wp config create --allow-root \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="$(cat ${WORDPRESS_DB_PASSWORD_FILE})" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --dbprefix="wp_"

    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="${WORDPRESS_TITLE}" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}"

    wp user create --allow-root \
        "${WORDPRESS_USER_LOGIN}" \
        "${WORDPRESS_USER_EMAIL}" \
        --role=author \
        --user_pass="${WORDPRESS_USER_PASSWORD}"

    # Ajusta as permissões para o utilizador www-data
    chown -R www-data:www-data /var/www/wordpress
fi

echo "Iniciando o PHP-FPM..."
exec php-fpm7.4 -F