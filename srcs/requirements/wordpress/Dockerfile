# Usa a mesma imagem base Debian dos outros serviços para consistência
FROM debian:bullseye-slim

# Instala as dependências necessárias de uma só vez para otimizar as camadas
# - php-fpm: O processador PHP
# - mariadb-client: Essencial para o loop de espera no entrypoint.sh
# - wget, unzip: Utilitários para baixar o wp-cli e outros ficheiros
# - Módulos PHP comuns para WordPress (gd, mysqli)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        php7.4-fpm \
        php7.4-mysql \
        mariadb-client \
        wget \
        unzip && \
    rm -rf /var/lib/apt/lists/*

# Instala o WP-CLI (ferramenta de linha de comando para WordPress)
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Copia a configuração personalizada do PHP para permitir uploads maiores
COPY conf/uploads.ini /etc/php/7.4/fpm/conf.d/

# Cria o diretório do WordPress e ajusta o proprietário para o utilizador do PHP-FPM
# O PHP-FPM no Debian corre como 'www-data' por padrão
RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

# Define o diretório de trabalho
WORKDIR /var/www/wordpress

# Copia e torna o script de inicialização executável
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Expõe a porta onde o PHP-FPM vai escutar as conexões do Nginx
EXPOSE 9000

# Define o utilizador para o qual o processo principal será executado
USER www-data

# Define o script de inicialização como o ponto de entrada
ENTRYPOINT [ "entrypoint.sh" ]

# Comando padrão que será executado pelo entrypoint
# O exec "$@" no final do teu entrypoint.sh irá executar este comando
CMD [ "php-fpm7.4", "-F" ]