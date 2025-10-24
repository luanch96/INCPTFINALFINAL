FROM debian:12-slim

RUN apt-get update && apt-get install -y \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-intl \
    php8.2-mbstring \
    php8.2-soap \
    php8.2-xml \
    php8.2-xmlrpc \
    php8.2-zip \
    php8.2-cli \
    wget \
    unzip \
    gettext-base \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/wordpress

RUN wget https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && mv wordpress/* /var/www/wordpress/ \
    && rm -rf wordpress latest.tar.gz

COPY tools/setup-admin.sh /usr/local/bin/setup-admin.sh
RUN chmod +x /usr/local/bin/setup-admin.sh

RUN sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/' /etc/php/8.2/fpm/pool.d/www.conf

COPY conf/wp-config-simple.php /var/www/wordpress/wp-config.php

RUN chown -R www-data:www-data /var/www/wordpress
RUN chmod -R 755 /var/www/wordpress

EXPOSE 9000

RUN echo '#!/bin/bash' > /docker-entrypoint.sh && \
    echo 'echo "WordPress container iniciado"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

RUN sed -i 's/;daemonize = yes/daemonize = no/' /etc/php/8.2/fpm/php-fpm.conf

CMD ["php-fpm8.2", "-F"]