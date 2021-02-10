FROM amazeeio/php:7.3-cli-drupal

COPY composer.json composer.lock /app/
COPY scripts /app/scripts

RUN composer install
COPY . /app

ENV WEBROOT=drupal/web