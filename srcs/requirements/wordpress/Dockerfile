    ARG PHP_VERSION=8.2
FROM php:${PHP_VERSION}-fpm

# dependências PHP + wp-cli
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip wget && \
        docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd mysqli zip opcache && \
    wget -q -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp && \
    rm -rf /var/lib/apt/lists/*

# baixa o core
RUN wget -q https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz -C /var/www && \
    rm latest.tar.gz

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

ENV WP_ADMIN_USER=admin \
    WP_ADMIN_EMAIL=admin@example.com \
    WP_AUTHOR_USER=autor \
    WP_AUTHOR_EMAIL=autor@example.com

WORKDIR /var/www/wordpress
VOLUME /var/www/wordpress
EXPOSE 9000
ENTRYPOINT ["entrypoint.sh"]
CMD ["php-fpm", "-F"]
