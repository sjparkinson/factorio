FROM alpine:3.12

LABEL \
  version="0.17.79" \
  description="Factorio is a game in which you build and maintain factories." \
  maintainer="sam.james.parkinson@gmail.com"

RUN apk --update --no-cache add curl ca-certificates && \
    addgroup -S factorio && \
    adduser -S factorio -G factorio && \
    mkdir -p /opt/factorio/saves && \
    chown -R factorio:factorio /opt/factorio && \
    curl -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    curl -Lo /tmp/glibc-2.31-r0.apk https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0.apk && \
    apk add /tmp/glibc-2.31-r0.apk && \
    rm -rf /tmp/* /var/cache/apk/*

USER factorio:factorio

WORKDIR /opt/factorio

RUN curl -L https://www.factorio.com/get-download/0.17.79/headless/linux64 | tar -C /opt -xJf -

VOLUME [ "/opt/factorio/saves" ]

EXPOSE 34197/udp

ENTRYPOINT [ "/opt/factorio/bin/x64/factorio", "--port", "34197" ]

CMD [ "--start-server-load-latest" ]
