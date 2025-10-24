#!/bin/bash

set -e

echo "🚀 Iniciando MariaDB..."

DB_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password)
DB_USER=$(cat /run/secrets/mariadb_user)
DB_PASSWORD=$(cat /run/secrets/mariadb_password)

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld /var/log/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "📦 Inicializando base de datos MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db
    echo "✅ Base de datos inicializada"
    
    echo "🔧 Configurando usuarios y base de datos..."
    
    mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0 &
    MYSQL_PID=$!
    
    sleep 5
    
    mysql -e "
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS wordpress;
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON wordpress.* TO '${DB_USER}'@'%';
        FLUSH PRIVILEGES;
    "
    
    kill $MYSQL_PID
    wait $MYSQL_PID
    
    echo "✅ Usuario y base de datos configurados"
fi

mkdir -p /var/run/mysqld
chown mysql:mysql /var/run/mysqld

echo "🔧 Iniciando MariaDB..."

exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0