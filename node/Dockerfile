FROM node

MAINTAINER HyanCat <hyancat@live.cn>

RUN npm install -g cnpm gulp bower && npm cache clear

COPY bin/notify-client-linux_amd64 /usr/bin/notify-send

WORKDIR /docker

VOLUME ["/docker"]
