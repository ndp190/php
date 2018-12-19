FROM php:7-fpm-alpine3.7

RUN set -xe \
    && apk add --no-cache bash \
        freetype \
        libpng \
        libjpeg-turbo \
        libmemcached-libs \
        gettext-libs \
        postgresql-libs \
        libxslt \
        libmcrypt \
        bzip2 \
        icu-libs \
        sqlite-libs \
    \
    && apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        bzip2-dev  \
        coreutils \
        curl-dev \
        cyrus-sasl-dev \
        freetype-dev \
        g++ \
        gettext-dev \
        icu-dev \
        libedit-dev \
        libressl-dev \
        libxml2-dev \
        libpng-dev \
        libjpeg-turbo-dev \
        libmemcached-dev \
        libmcrypt-dev \
        libxslt-dev \
        postgresql-dev \
        sqlite-dev \
    \
    && export CFLAGS="$PHP_CFLAGS" \
        CPPFLAGS="$PHP_CPPFLAGS" \
        LDFLAGS="$PHP_LDFLAGS" \
    \
    && docker-php-ext-install -j$(nproc) bcmath \
        bz2 \
        calendar \
        exif \
        gd \
        gettext \
        intl \
        mysqli \
        pgsql \
        pdo_mysql \
        pdo_pgsql \
        pdo_sqlite \
        soap \
        sockets \
        wddx \
        xsl \
        zip \
        opcache \
    \
    && pecl install mcrypt-snapshot memcached msgpack redis\
    && docker-php-ext-enable mcrypt memcached msgpack redis \
    && apk del .build-deps \
    && rm -rf /tmp/*
