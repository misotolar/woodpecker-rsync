FROM --platform=$BUILDPLATFORM alpine:3.19.1

LABEL maintainer="michal@sotolar.com"

RUN set -ex; \
    apk add --no-cache --update \
        bash \
        ca-certificates \
        openssh \
        sshpass \
        rsync \
    ; \
    rm -rf \
        /var/cache/apk/* \
        /var/tmp/* \
        /tmp/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
