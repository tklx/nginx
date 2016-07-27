FROM tklx/base:0.1.0

ENV TINI_VERSION=v0.9.0
RUN set -x \
    && TINI_URL=https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini \
    && TINI_GPGKEY=0527A9B7 \
    && export GNUPGHOME="$(mktemp -d)" \
    && apt-get update && apt-get -y install wget ca-certificates \
    && wget -O /tini ${TINI_URL} \
    && wget -O /tini.asc ${TINI_URL}.asc \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys ${TINI_GPGKEY} \
    && gpg --verify /tini.asc \
    && chmod +x /tini \
    && rm -r ${GNUPGHOME} /tini.asc \
    && apt-get purge -y --auto-remove wget ca-certificates \
    && apt-clean --aggressive

ENV GOSU_VERSION=1.9
RUN set -x \
    && GOSU_URL=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-$(dpkg --print-architecture) \
    && GOSU_GPGKEY=B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && export GNUPGHOME="$(mktemp -d)" \
    && apt-get update && apt-get -y install wget ca-certificates \
    && wget -O /usr/local/sbin/gosu ${GOSU_URL} \
    && wget -O /usr/local/sbin/gosu.asc ${GOSU_URL}.asc \
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys ${GOSU_GPGKEY} \
    && gpg --verify /usr/local/sbin/gosu.asc \
    && chmod +x /usr/local/sbin/gosu && gosu nobody true \
    && rm -r ${GNUPGHOME} /usr/local/sbin/gosu.asc \
    && apt-get purge -y --auto-remove wget ca-certificates \
    && apt-clean --aggressive

RUN set -x \
    && apt-get update \
    && apt-get -y install nginx \
    && apt-clean --aggressive

COPY overlay /

EXPOSE 80 443
VOLUME /var/www

ENTRYPOINT ["/tini", "--"]
CMD ["nginx"]
