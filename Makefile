################################################################

# 官方原版镜像库
pull:
	docker pull nginx
	docker pull php:fpm
	docker pull mysql
	docker pull memcached
	docker pull redis

# 下载 php 扩展
download:
	mkdir php/ext
	wget http://pecl.php.net/get/redis-2.2.7.tgz -O php/ext/redis.tgz
	wget http://pecl.php.net/get/memcached-2.2.0.tgz -O php/ext/memcached.tgz
	wget http://pecl.php.net/get/xdebug-2.3.2.tgz -O php/ext/xdebug.tgz
	wget http://pecl.php.net/get/memcache-2.2.7.tgz -O php/ext/memcache.tgz

# Dockerfile 批量构建 Images
build:
	make build-nginx
	make build-php
	make build-mysql
	make build-memcached
	make build-redis

# Docker Container 依次运行
run:
	make run-php
	make run-nginx
	make run-mysql
	make run-memcached
	make run-redis

# Docker Container 重启
restart:
	docker restart phpfpm
	docker restart nginx-server
	docker restart mysql-server

# Docker Container 停止并删除
stop:
	docker stop phpfpm
	docker stop nginx-server
	docker stop mysql-server
	docker rm phpfpm
	docker rm nginx-server
	docker stop mysql-server

# Docker Container Logs
log:
	docker logs -f nginx-server

################################################################

build-nginx:
	docker build -t hyancat/nginx ./nginx

run-nginx:
	docker run --name nginx-server -d -p 80:80 --link phpfpm:phpfpm -v ~/docker/app:/app --volumes-from phpfpm -t hyancat/nginx

in-nginx:
	docker run -i -p 80:80 -v ~/docker/app:/app -t hyancat/nginx /bin/bash

################################################################

build-php:
	docker build -t hyancat/php ./php

run-php:
	docker run --name phpfpm -d -v ~/docker/app:/app -t hyancat/php

in-php:
	docker run -i -p 9000:9000 -v ~/docker/app:/app -t hyancat/php /bin/bash

################################################################

build-mysql:
	docker build -t hyancat/mysql ./mysql

run-mysql:
	docker run --name mysql-server -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -t hyancat/mysql

in-mysql:
	docker run -i -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret -t hyancat/mysql /bin/bash

################################################################

build-memcached:
	docker build -t hyancat/memcached ./memcached

run-memcached:
	docker run --name memcached-server -d -p 11211:11211 -t hyancat/memcached

################################################################

build-redis:
	docker build -t hyancat/redis ./redis

run-redis:
	docker run --name redis-server -d -p 6379:6379 -t hyancat/redis

################################################################

# 清除无效 Images
clean:
	docker rmi $(shell docker images | grep "<none>" | awk '{print $$3}')

# 停止所有 Containers （慎重）
stop-all:
	docker stop $(shell docker ps -a | grep -v "CONTAINER ID" | awk '{print $$1}')

# 停止并删除所有 Containers （慎重）
delete-all:
	make stop-all
	docker rm $(shell docker ps -a | grep -v "CONTAINER ID" | awk '{print $$1}')
