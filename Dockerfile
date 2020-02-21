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
