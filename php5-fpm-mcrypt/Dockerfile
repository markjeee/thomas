FROM php:5-fpm
MAINTAINER Mark John Buenconsejo <mark@nlevel.io>

RUN apt-get -qq update && \
    apt-get -qq install -y libmcrypt-dev && \
    docker-php-ext-install mcrypt

RUN apt-get autoremove --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
