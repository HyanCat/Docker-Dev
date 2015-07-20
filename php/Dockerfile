FROM php:fpm

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
        && rm -r /var/lib/apt/lists/*


# Install PHP extensions

COPY ext/memcached.tgz /home/memcached.tgz
COPY ext/redis.tgz /home/redis.tgz
COPY ext/xdebug.tgz /home/xdebug.tgz
COPY ext/memcache.tgz /home/memcache.tgz

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install zip \
        && docker-php-ext-install gd \
        && docker-php-ext-install mbstring \
        && docker-php-ext-install mcrypt \
        && docker-php-ext-install pdo_mysql
RUN pecl install /home/memcached.tgz && echo "extension=memcached.so" > /usr/local/etc/php/conf.d/memcached.ini \
        && pecl install /home/redis.tgz && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini \
        && pecl install /home/memcache.tgz && echo "extension=memcache.so" > /usr/local/etc/php/conf.d/memcache.ini \
        && pecl install /home/xdebug.tgz && echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20131226/xdebug.so" > /usr/local/etc/php/conf.d/xdebug.ini

# PHP config

ADD php-fpm.conf    /usr/local/etc/php-fpm.conf

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
