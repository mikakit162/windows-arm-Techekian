FROM scratch
COPY --from=qemux/qemu-arm:7.07 / /

ARG VERSION_ARG="0.00"
ARG DEBCONF_NOWARNINGS="yes"
ARG DEBIAN_FRONTEND="noninteractive"
ARG DEBCONF_NONINTERACTIVE_SEEN="true"

RUN set -eu && \
    apt-get update && \
    apt-get --no-install-recommends -y install \
        wsdd \
        samba \
        wimtools \
        dos2unix \
        cabextract \
        libxml2-utils \
        libarchive-tools && \
    apt-get clean && \
    echo "$VERSION_ARG" > /run/version && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --chmod=755 ./src /run/
COPY --chmod=755 ./assets /run/assets

ADD --chmod=664 https://github.com/qemus/virtiso-arm/releases/download/v0.1.266-1/virtio-win-0.1.266.tar.xz /drivers.txz

VOLUME /storage
EXPOSE 3389 8006

ENV VERSION="10"
ENV RAM_SIZE="8G"
ENV CPU_CORES="4"
ENV DISK_SIZE="256G"

ENTRYPOINT ["/usr/bin/tini", "-s", "/run/entry.sh"]
