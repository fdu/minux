FROM debian:bullseye

ENV URL_BUILDROOT https://buildroot.org/downloads/buildroot-2021.02.4.tar.gz

RUN apt update
RUN apt install -y curl bc rsync build-essential file wget cpio unzip git libncurses-dev libssl-dev libelf-dev
RUN curl $URL_BUILDROOT > buildroot.tar.gz

RUN mkdir -p buildroot_amd64
RUN tar zxf buildroot.tar.gz -C buildroot_amd64 --strip-components=1
COPY buildroot/configs/amd64/buildroot /buildroot_amd64/.config

RUN mkdir -p buildroot_arm64
RUN tar zxf buildroot.tar.gz -C buildroot_arm64 --strip-components=1
COPY buildroot/configs/arm64/buildroot /buildroot_arm64/.config
COPY buildroot/configs/arm64/kernel /buildroot_arm64/kernel

COPY buildroot/build.sh /
CMD /build.sh
