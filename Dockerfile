FROM alpine:3.3

RUN syncthing_version="v0.13.6" && \
    syncthing_sha256="af195e75aa07b9c4a07507b82013e3e2f9f5244cffad3810c9204076b05f0d5e" && \
    apk add --update ca-certificates file && \
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
    apk del ca-certificates && \
    rm -rf /var/cache/apk/* && \
    mkdir /data && \
    adduser -u 500 -h /data -D syncthing

USER syncthing
EXPOSE 22000 "21027/udp"
VOLUME ["/data"]
ENTRYPOINT ["/usr/local/bin/syncthing"]
