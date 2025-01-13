FROM --platform=$BUILDPLATFORM misotolar/alpine:3.21.2

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

COPY resources/entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
