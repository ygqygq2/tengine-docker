## Dockerfile
FROM centos:7

LABEL maintainer "29ygq@sina.com"

ENV TENGINE_VERSION="2.3.2" \
  TENGINE_BASEDIR="/usr/local/nginx"

#get all the dependences and nginx
RUN yum install -y git gcc make wget pcre pcre-devel openssl openssl-devel \
  && rm -rf /var/cache/yum/* \
  && mkdir -p ${TENGINE_BASEDIR}/tmp \
  && mkdir -p ${TENGINE_BASEDIR}/conf/vhost

WORKDIR /tmp

## comile tengine
# tengine url: http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz
RUN wget http://tengine.taobao.org/download/tengine-${TENGINE_VERSION}.tar.gz \
  && tar -zxf tengine-${TENGINE_VERSION}.tar.gz \
  && cd tengine-${TENGINE_VERSION} \
  && ./configure --prefix=${TENGINE_BASEDIR} \
  && make \
  && make install \
  && ln -s ${TENGINE_BASEDIR}/sbin/nginx /usr/bin/ \
  && ln -sf /dev/stdout ${TENGINE_BASEDIR}/logs/access.log \
  && ln -sf /dev/stderr ${TENGINE_BASEDIR}/logs/error.log \
  && rm -rf tengine-${TENGINE_VERSION} tengine-${TENGINE_VERSION}.tar.gz


EXPOSE 8080

COPY nginx.conf ${TENGINE_BASEDIR}/conf/

WORKDIR ${TENGINE_BASEDIR}/conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]
