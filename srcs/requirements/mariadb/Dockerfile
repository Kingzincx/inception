FROM debian:bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends mariadb-server procps && \
    rm -rf /var/lib/apt/lists/*

COPY conf/my.cnf /etc/mysql/conf.d/

COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /var/lib/mysql
EXPOSE 3306
ENTRYPOINT ["entrypoint.sh"]
CMD ["mariadbd", "--user=mysql", "--console", "--skip-name-resolve", "--bind-address=0.0.0.0"]
