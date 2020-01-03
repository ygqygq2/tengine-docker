## Dockerfile
FROM centos:7

LABEL maintainer "29ygq@sina.com"

ENV TENGINE_VERSION="2.3.2"

#get all the dependences and nginx
RUN yum install -y git gcc make wget pcre pcre-devel openssl openssl-devel \
  && rm -rf /var/cache/yum/* \
  && mkdir -p /usr/local/nginx/tmp \
  && mkdir -p /usr/local/nginx/conf/vhost

WORKDIR /tmp

## comile tengine
# tengine url: http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz
RUN wget http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz \
  && tar -zxf tengine-${TENGINE_VERSION}.tar.gz \
  && cd tengine-${TENGINE_VERSION} \
  && ./configure --prefix=/usr/local/nginx \
  && make \
  && make install \
  && ln -s /usr/local/nginx/sbin/nginx /usr/bin/ \
  && rm -rf tengine-${TENGINE_VERSION} tengine-${TENGINE_VERSION}.tar.gz


EXPOSE 8080

COPY nginx.conf /usr/local/nginx/conf/

WORKDIR /usr/local/nginx/conf

CMD ["nginx"]
