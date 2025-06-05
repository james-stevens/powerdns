# (c) Copyright 2019-2020, James Stevens ... see LICENSE for details
# Alternative license arrangements are possible, contact me for more information

FROM alpine:3.18

RUN apk update
RUN apk upgrade

RUN rmdir /tmp /run
RUN ln -s /dev/shm /tmp
RUN ln -s /dev/shm /run

RUN apk add pdns pdns-backend-mysql
RUN apk add nginx
RUN ln -fns /run/nginx.conf /etc/nginx/nginx.conf
RUN ln -fns /run/pdns.conf /etc/pdns/pdns.conf

RUN apk add python3
RUN apk add py3-dnspython py3-requests

RUN rmdir /var/lib/nginx/tmp /var/log/nginx 
RUN ln -s /dev/shm /var/lib/nginx/tmp
RUN ln -s /dev/shm /var/log/nginx
RUN ln -s /dev/shm /run/nginx

COPY inittab /etc/inittab
COPY htpasswd /etc/nginx/htpasswd
RUN chown -R nginx: /etc/nginx/htpasswd
COPY inittab /etc/inittab

COPY htdocs /opt/htdocs/
RUN chown -R nginx: /opt/htdocs

COPY bin /usr/local/bin/
COPY etc /usr/local/etc/
COPY python /usr/local/python/
RUN python3 -m compileall /usr/local/python/

CMD [ "/usr/local/bin/run_init" ]
