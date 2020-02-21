# Gentle Example for Docker / Nginx / uWSGI / Flask
This is sample for Docker + nginx + uwsgi + flask.  

## Dockerfile
Dockerfile is the configuration for `docker build`.  
Run `docker build -t "tag/name" .` to build this repo in a image.
```docker
FROM ubuntu:latest
COPY . /app
WORKDIR /app

ENTRYPOINT ["/bin/sh", "-c" , "service nginx start && uwsgi --ini uwsgi.ini"]

RUN apt-get clean \
    && apt-get -y update

RUN apt-get -y install nginx \
    && apt-get -y install python3 \
    && apt-get -y install python3-pip \
    && apt-get -y install build-essential \
    && apt-get -y install git

RUN pip3 install -r requirements.txt

COPY nginx.conf /etc/nginx

ENV WSGIPath application.py

EXPOSE 80

```

## Nginx Configuration
```nginx
user www-data; # set user www-data group
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    access_log /var/log/nginx/access.log; # log to /var/log/nginx
    error_log /var/log/nginx/error.log; # log to /var/log/nginx

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    index   index.html index.htm;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  localhost;
        root         /var/www/html;

        location / {
            include uwsgi_params; # uwsgi connection with nginx
            uwsgi_pass unix:/tmp/uwsgi.socket; # uwsgi socket file path
        }
    }
}
```

## uWSGI Configuration
```ini
[uwsgi]
wsgi-file = application.py # wsgi file setting
uid = www-data # set user group
gid = www-data # set user group
master = true
processes = 4

socket = /tmp/uwsgi.socket # socket file path
chmod-sock = 664
vacuum = true

die-on-term = true
```
