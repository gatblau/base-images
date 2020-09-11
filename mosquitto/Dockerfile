FROM centos:8 as builder
ARG VERSION
RUN dnf install -y epel-release
RUN dnf install -y mosquitto-${VERSION}.el8.x86_64 unzip git
WORKDIR /app
RUN curl -L -o boot.zip https://github.com/gatblau/boot/raw/master/build/boot_linux_amd64.zip && \
    unzip boot.zip

FROM registry.access.redhat.com/ubi8/ubi-minimal
LABEL author="gatblau"
LABEL maintainer="onix@gatblau.org"
ARG UNAME=mosquitto
ENV UID=1000
ENV GID=1000
RUN microdnf update --disablerepo=* --enablerepo=ubi-8-appstream --enablerepo=ubi-8-baseos -y && \
    microdnf install shadow-utils.x86_64 && groupadd -g $GID -o $UNAME && useradd -M -u $UID -g $GID $UNAME && \
    rm -rf /var/cache/yum && \
    microdnf clean all
USER $UNAME
COPY --from=builder --chown=$UNAME /usr/sbin/mosquitto /app/
COPY --from=builder --chown=$UNAME /usr/lib64/libwebsockets.so.16 /usr/lib64/libev.so.4  /usr/lib64/libuv.so.1 /usr/lib64/
COPY --from=builder --chown=$UNAME /app/boot /app/
COPY --chown=$UNAME mosquitto.conf pwd.txt start.sh /app/
CMD ["sh", "/app/start.sh", "/app/mosquitto", "-c", "/app/mosquitto.conf"]