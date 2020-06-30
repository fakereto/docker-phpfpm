FROM ubuntu:bionic
MAINTAINER Andres Vejar <andresvejar@neubox.net>

ENV OS_LOCALE="en_US.UTF-8" \
    DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y locales && locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
    LANGUAGE=${OS_LOCALE} \
    LC_ALL=${OS_LOCALE}

ENV PHP_RUN_DIR=/run/php \
    PHP_LOG_DIR=/var/log/php \
    PHP_CONF_DIR=/etc/php/7.3 \
    PHP_DATA_DIR=/var/lib/php

RUN \
    BUILD_DEPS='software-properties-common python3-software-properties' \
    && dpkg-reconfigure locales \
    # Install common libraries
    && apt-get install --no-install-recommends -y $BUILD_DEPS \
    && add-apt-repository -y ppa:ondrej/php \
    && apt-get update --fix-missing \
    # Install PHP libraries
    && apt-get install -y curl php7.3-fpm \
    php7.3-cli php7.3-readline php7.3-mbstring \
    php7.3-zip php7.3-intl php7.3-json php7.3-xml \
    php7.3-curl php7.3-gd php7.3-mysql \
    php7.3-bcmath php7.3-ctype php7.3-pdo php7.3-mongodb php7.3-redis php-pear unzip\
    && phpenmod mcrypt \
    # Install composer
    && curl -sS https://getcomposer.org/installer | php -- --version=1.9.0 --install-dir=/usr/local/bin --filename=composer \
    && mkdir -p ${PHP_LOG_DIR} ${PHP_RUN_DIR} \
    # Cleaning
    && apt-get purge -y --auto-remove $BUILD_DEPS \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY ./configs/php-fpm.conf ${PHP_CONF_DIR}/fpm/php-fpm.conf
COPY ./configs/www.conf ${PHP_CONF_DIR}/fpm/pool.d/www.conf
COPY ./configs/php.ini ${PHP_CONF_DIR}/fpm/conf.d/custom.ini

RUN sed -i "s~PHP_RUN_DIR~${PHP_RUN_DIR}~g" ${PHP_CONF_DIR}/fpm/php-fpm.conf \
    && sed -i "s~PHP_LOG_DIR~${PHP_LOG_DIR}~g" ${PHP_CONF_DIR}/fpm/php-fpm.conf \
    && sed -i "s~PHP_RUN_DIR~${PHP_RUN_DIR}~g" ${PHP_CONF_DIR}/fpm/pool.d/www.conf \
    && chown www-data:www-data ${PHP_DATA_DIR} -Rf

WORKDIR /var/www

EXPOSE 9000

# PHP_DATA_DIR store sessions
VOLUME ["${PHP_RUN_DIR}", "${PHP_DATA_DIR}"]
CMD ["/usr/sbin/php-fpm7.3"]
