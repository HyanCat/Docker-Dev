FROM nginx

# Nginx Config
ADD nginx.conf /etc/nginx/nginx.conf
ADD conf.d/*.conf /etc/nginx/conf.d/

# User Permission
RUN useradd -M -s /usr/sbin/nologin webuser

RUN mkdir /app
RUN chown -R webuser.webuser /app

WORKDIR /app

EXPOSE 80

VOLUME ["/app"]
