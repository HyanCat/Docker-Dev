FROM php:7-fpm

MAINTAINER HyanCat <hyancat@live.cn>

# Prepare Env

ADD sources.list    /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
        git \
        libmemcached-dev \
        libmcrypt-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        imagemagick \
        libmagickwand-dev \
        libssl-dev

RUN apt-get autoremove -y && apt-get clean && rm -r /var/lib/apt/lists/*


RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install zip \
        && docker-php-ext-install gd \
        && docker-php-ext-install mbstring \
        && docker-php-ext-install mcrypt \
        && docker-php-ext-install pdo_mysql \
        && docker-php-ext-install opcache

# PHP config

ADD conf.d/php-fpm.conf /usr/local/etc/php-fpm.conf

ADD conf.d/php.ini /usr/local/etc/php/php.ini

# Composer

ADD bin/composer /usr/local/bin/composer
RUN chmod 755 /usr/local/bin/composer

# User Permission

RUN useradd -M -s /usr/sbin/nologin webuser
RUN usermod -u 1000 webuser

RUN mkdir /docker
RUN chown -R webuser.webuser /docker
WORKDIR /docker

EXPOSE 9000
VOLUME ["/docker"]
