FROM php:5.6-cli

MAINTAINER dev@dankempster.co.uk

RUN buildDeps=" \
        zlib1g-dev \
        libmcrypt-dev \
        libxml2-dev \
        libssl-dev \
        libxslt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libicu-dev \
    " \
    && envDeps=" \
        libmcrypt4 \
        libxslt1.1 \
        libfreetype6 \
        libjpeg62-turbo \
        libpng12-0 \
        libicu52 \
        \
        git \
        zip \
        unzip \
    " \
    && set -x \
    && apt-get update && apt-get install -y $buildDeps $envDeps --no-install-recommends && rm -rf /var/lib/apt/lists/* \
    \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    \
    && docker-php-ext-install \
        gd \
        pdo_mysql \
        intl \
        dom \
        zip \
        mcrypt \
        bcmath \
        mbstring \
        gettext \
        xsl \
    \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false $buildDeps \
    && apt-get clean \
    \
    && mkdir /project \
    && chown -R www-data:www-data /project \
    && chmod -R 2775 /project


# Set PHP config
COPY config/*.ini /usr/local/etc/php/conf.d/

WORKDIR /project
