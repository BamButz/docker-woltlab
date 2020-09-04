#!/bin/sh
service cron start
service nginx start

WOLTLAB_SOURCE=/opt/woltlab
HTML_ROOT=/var/www/woltlab

if ! [ "$(ls -A $HTML_ROOT)" ]; then
    echo "Copy source files to web root"
    mv $WOLTLAB_SOURCE/* $HTML_ROOT
    chown -R www-data:www-data $HTML_ROOT
fi

{ php-fpm & tail -f /var/log/nginx/access.log;}