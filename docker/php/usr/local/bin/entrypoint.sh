#!/bin/bash

# unit tests run as root or www-data need to write here
chmod -R ugo+wx public/test-coverage-report

rm -rf /var/www/vendor
cp -a /tmp/composer/vendor/. /var/www/vendor/

exec php-fpm
