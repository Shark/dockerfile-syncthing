FROM alpine:3.3

RUN syncthing_version="v0.12.20" && \
    syncthing_sha256="ee72dabc1d0399fa019e68597d4a783c16205a8141e36afad7af01e1d066d46b" && \
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
