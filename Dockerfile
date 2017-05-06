FROM alpine:3.3

RUN syncthing_version="v0.14.27" && \
    syncthing_sha256="8a0b85bf4fed32f8e3b5234e26aae570df4975e91c6e079d1516d374ad2c2980" && \
    apk add --update ca-certificates openssl file && \
    update-ca-certificates && \
    tempdir=$(mktemp -d) && \
    cd $tempdir && \
    wget -O syncthing.tar.gz  https://github.com/syncthing/syncthing/releases/download/${syncthing_version}/syncthing-linux-amd64-${syncthing_version}.tar.gz && \
    syncthing_actual_sha256=$(sha256sum syncthing.tar.gz) && \
    if [ "${syncthing_sha256}  syncthing.tar.gz" != "$syncthing_actual_sha256" ]; then exit 999; fi && \
    echo "sha256 expected: ${syncthing_sha256}  syncthing.tar.gz" && \
    echo "sha256 actual:   ${syncthing_actual_sha256}" && \
    tar xzf syncthing.tar.gz && \
    file syncthing-linux-amd64-${syncthing_version}/syncthing && \
    mv syncthing-linux-amd64-${syncthing_version}/syncthing /usr/local/bin && \
    cd / && \
    rm -r $tempdir && \
    apk del ca-certificates openssl && \
    rm -rf /var/cache/apk/* && \
    mkdir /data && \
    adduser -u 500 -h /data -D syncthing

USER syncthing
EXPOSE 22000 "21027/udp"
VOLUME ["/data"]
ENTRYPOINT ["/usr/local/bin/syncthing"]
