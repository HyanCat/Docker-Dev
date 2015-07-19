################################################################
####                         Main                          #####
################################################################

# 官方原版镜像库
pull:
	docker pull nginx
	docker pull php:fpm
	docker pull mysql
	docker pull memcached
	docker pull redis
	docker pull nodejs

download:
	# 下载 php 扩展
	wget http://pecl.php.net/get/redis-2.2.7.tgz -O php/ext/redis.tgz
	wget http://pecl.php.net/get/memcached-2.2.0.tgz -O php/ext/memcached.tgz
	wget http://pecl.php.net/get/xdebug-2.3.2.tgz -O php/ext/xdebug.tgz
	wget http://pecl.php.net/get/memcache-2.2.7.tgz -O php/ext/memcache.tgz
	wget http://getcomposer.org/composer.phar -O php/bin/composer

# Dockerfile 批量构建 Images
build:
	make build-nginx
	make build-php
	make build-mysql
	make build-memcached
	make build-redis
	make build-node
	docker images

# Docker Container 依次运行
run:
	make run-php
	make run-nginx
	make run-mysql
	make run-memcached
	make run-redis
	docker ps

# Docker Container 重启
restart:
	docker restart phpfpm
	docker restart nginx-server
	docker restart mysql-server
	docker restart memcached-server
	docker restart redis-server
	docker ps

# Docker Container 停止并删除
stop:
	docker stop phpfpm
	docker stop nginx-server
	docker stop mysql-server
	docker stop memcached-server
	docker stop redis-server
	docker rm phpfpm
	docker rm nginx-server
	docker rm mysql-server
	docker rm memcached-server
	docker rm redis-server

# Docker Container Logs
log:
	docker logs -f nginx-server

################################################################
####                         Nginx                         #####
################################################################

build-nginx:
	docker build -t hyancat/nginx ./nginx

run-nginx:
	docker run --name nginx-server -d -p 80:80 \
		--link phpfpm:phpfpm \
		-v ~/Code:/docker/code \
		-t hyancat/nginx

in-nginx:
	docker exec -it nginx-server /bin/bash

new-nginx:
	docker run -i -v ~/Code:/docker/code -t hyancat/nginx /bin/bash

################################################################
####                          PHP                          #####
################################################################

build-php:
	docker build -t hyancat/php ./php

run-php:
	docker run --name phpfpm -d -v ~/Code:/docker/code -t hyancat/php

in-php:
	docker exec -it phpfpm /bin/bash

new-php:
	docker run -i -v ~/Code:/docker/code -t hyancat/php /bin/bash

################################################################
####                         MySQL                         #####
################################################################

MYSQL_ROOT_PASSWORD = secret

build-mysql:
	docker build -t hyancat/mysql ./mysql

run-mysql:
	docker run --name mysql-server -d -p 3306:3306 \
		-e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} \
		-t hyancat/mysql

in-mysql:
	docker exec -it mysql-server /bin/bash

new-mysql:
	docker run -i -e MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} -t hyancat/mysql /bin/bash

################################################################
####                       Memcached                       #####
################################################################

build-memcached:
	docker build -t hyancat/memcached ./memcached

run-memcached:
	docker run --name memcached-server -d -p 11211:11211 -t hyancat/memcached

################################################################
####  Redis  ####

build-redis:
	docker build -t hyancat/redis ./redis

run-redis:
	docker run --name redis-server -d -p 6379:6379 -t hyancat/redis

################################################################
####                        Nodejs                         #####
################################################################

DOCKER_BRIDGE_IP = $(shell ifconfig en0 | grep 'inet ' | awk '{ print $$2}')
NOTIFY_PORT = 13579

build-node:
	docker build -t hyancat/nodejs ./node

new-node:
	docker run --rm -it \
		-v ~/Code:/docker/code \
		-e NOTIFY_SEND_URL="http://${DOCKER_BRIDGE_IP}:${NOTIFY_PORT}" \
		hyancat/nodejs \
		/bin/bash

################################################################
####                        Others                         #####
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
