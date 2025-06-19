#!/bin/sh
set -e

# 1. inicializa bd se volume estiver vazio
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --ldata=/var/lib/mysql
    TEMP_PIDFILE=/tmp/mariadb.pid
    mariadbd --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock --pid-file=$TEMP_PIDFILE &
    pid="$!"

    # espera servidor subir
    for i in $(seq 30); do
        mysqladmin ping --socket=/run/mysqld/mysqld.sock --silent && break
        sleep 1
    done

    mysql --socket=/run/mysqld/mysqld.sock <<-EOSQL
        SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$(cat ${MYSQL_ROOT_PASSWORD_FILE})');
        DELETE FROM mysql.user WHERE User='';
        CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat ${MYSQL_PASSWORD_FILE})';
        GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL

    kill "$pid"
    wait "$pid"
fi

exec "$@"
