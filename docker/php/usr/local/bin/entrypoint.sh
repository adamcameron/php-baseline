#!/bin/bash

# unit tests run as root or www-data need to write here
chmod -R ugo+wx public/test-coverage-report

rm -rf vendor
composer install
exec php-fpm
