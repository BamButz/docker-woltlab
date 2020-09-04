FROM php:7.2-fpm

# Install NGINX
RUN apt-get update && apt-get install -y nginx

# Install Dependencies
RUN apt-get install -y \
        libpng-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libjpeg-dev \
        libpq-dev \
        libpq5 \
        libjpeg62-turbo \
        libfreetype6 \
        git \
        wget \
        unzip \
        libmagickwand-dev \
        cron

# Install PHP Extensions
RUN docker-php-ext-install pdo_mysql mysqli && \
    docker-php-ext-install pdo_pgsql && \
    docker-php-ext-install gd && \
    docker-php-ext-install exif && \
    pecl install imagick && \
    docker-php-ext-enable imagick

# Include Woltlab Setup
RUN wget -O /tmp/woltlab.zip https://assets.woltlab.com/release/woltlab-suite-5.2.9.zip && \
    unzip /tmp/woltlab.zip -d /tmp/woltlab && \
    mkdir -p /var/www/woltlab && \
    mkdir -p /opt/woltlab && \
    mv /tmp/woltlab/upload/* /opt/woltlab

# Setup crontab
COPY cron.php /opt/woltlab/cron.php
COPY crontab /etc/cron.d/woltlab-cron
RUN chmod 0644 /etc/cron.d/woltlab-cron
RUN crontab /etc/cron.d/woltlab-cron

COPY nginx-site.conf /etc/nginx/sites-enabled/default
COPY entrypoint.sh /etc/entrypoint.sh

EXPOSE 80
WORKDIR /var/www/woltlab
ENTRYPOINT ["sh", "/etc/entrypoint.sh"]
