FROM ubuntu:26.04 AS source

ADD --checksum=sha256:f67403104687a301e27fb3a1efed7bfebf6add997ad0f3dea465a5797cbea220 https://cdn.waterfox.com/waterfox/releases/6.6.17/Linux_x86_64/waterfox-6.6.17.tar.bz2 /tmp/app.tar.bz2

RUN apt-get update && \
    apt-get install -y --no-install-recommends bzip2 && \
    mkdir -p /out && \
    tar -xjf /tmp/app.tar.bz2 -C /out

FROM ghcr.io/containerpak/gtk3:main

LABEL org.opencontainers.image.source="https://github.com/Containerpak/waterfox"

COPY --from=source /out/waterfox /opt/waterfox

RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates libdbus-glib-1-2 libnss3 libx11-xcb1 libxt6 xdg-utils && \
    ln -sf /opt/waterfox/waterfox /usr/bin/waterfox && \
    cpak-clean-junk

COPY icon.png /usr/share/icons/hicolor/128x128/apps/waterfox.png
COPY waterfox.desktop /usr/share/applications/waterfox.desktop
