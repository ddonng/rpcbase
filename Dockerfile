FROM php:7-cli
MAINTAINER XiaodongHuang <ddonng@qq.com>

RUN apt-get update && apt-get install -y git zlib1g-dev && docker-php-ext-install pdo_mysql && docker-php-ext-install sockets

RUN apt-get install -y libmemcached11 libmemcachedutil2 build-essential libmemcached-dev libz-dev
RUN git clone -b php7 https://github.com/php-memcached-dev/php-memcached.git && cd php-memcached && phpize && ./configure && make && make install \
    && echo "extension=memcached.so" >> /usr/local/etc/php/conf.d/memcached.ini

RUN pecl install -o -f redis-3.0.0 \
    && rm -rf /tmp/pear \
    && echo "extension=redis.so" >> /usr/local/etc/php/conf.d/redis.ini

RUN apt-get install -y pkg-config libssl-dev && pecl install mongodb-1.1.8 && echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini

RUN apt-get install -y libpcre3-dev openssl libssl-dev && git clone --depth=1 http://github.com/phalcon/cphalcon &&cd cphalcon/build && ./install \
    && echo extension=phalcon.so >> /usr/local/etc/php/conf.d/phalcon.ini
RUN rm -rf cphalcon

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN pecl install swoole-1.8.12 && echo extension=swoole.so >> /usr/local/etc/php/conf.d/swoole.ini
RUN echo date.timezone = PRC >> /usr/local/etc/php/php.ini

RUN apt-get remove -y build-essential libmemcached-dev libz-dev git\
    && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /home/www/
VOLUME ["/home/www/"]
