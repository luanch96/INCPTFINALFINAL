#!/bin/bash

echo "🔧 Configurando base de datos WordPress..."

echo "⏳ Esperando a que MariaDB esté listo..."
while ! docker exec mariadb mysqladmin ping --silent --socket=/var/run/mysqld/mysqld.sock 2>/dev/null; do
    sleep 2
    echo "Esperando..."
done

echo "✅ MariaDB está listo"

echo "🗄️ Creando base de datos WordPress..."
docker exec mariadb mysql --socket=/var/run/mysqld/mysqld.sock -e "
CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wpuser'@'%' IDENTIFIED BY 'wppassword';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'%';
FLUSH PRIVILEGES;
"

echo "✅ Base de datos configurada correctamente"
echo "🎉 ¡Proyecto Inception listo!"
echo "🌐 Accede a: https://luisanch.42.fr"


