FROM debian:bullseye

ENV SERVER_ROOT /var/www/html

RUN dpkg --add-architecture arm64
RUN apt update
RUN apt install -y dnsmasq iproute2 ipxe nginx grub-efi curl grub-efi-arm64-bin

RUN mkdir -p $SERVER_ROOT/boot
COPY netboot/system/grub-chain.cfg /grub-chain.cfg
RUN grub-mkstandalone \
	-O x86_64-efi \
	-o $SERVER_ROOT/boot/grub-x86_64.efi \
	--modules="tftp net efinet linux efifwsetup part_msdos part_gpt btrfs ext2 fat http" \
	/boot/grub/grub.cfg=/grub-chain.cfg
RUN grub-mkstandalone \
	-O arm64-efi \
	-o $SERVER_ROOT/boot/grub-arm64.efi \
	--modules="tftp net efinet linux efifwsetup part_msdos part_gpt btrfs ext2 fat http" \
	/boot/grub/grub.cfg=/grub-chain.cfg
RUN mkdir -p $SERVER_ROOT/images/amd64/bullseye
RUN mkdir -p $SERVER_ROOT/images/arm64/bullseye
COPY netboot/system/start.sh /
CMD /start.sh

#RUN curl http://ftp.fr.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/debian-installer/amd64/linux > $SERVER_ROOT/images/amd64/bullseye/linux
#RUN curl http://ftp.fr.debian.org/debian/dists/buster/main/installer-amd64/current/images/netboot/debian-installer/amd64/initrd.gz > $SERVER_ROOT/images/amd64/bullseye/initrd.gz
#RUN curl http://ftp.fr.debian.org/debian/dists/buster/main/installer-arm64/current/images/netboot/debian-installer/arm64/linux > $SERVER_ROOT/images/arm64/bullseye/linux
#RUN curl http://ftp.fr.debian.org/debian/dists/buster/main/installer-arm64/current/images/netboot/debian-installer/arm64/initrd.gz > $SERVER_ROOT/images/arm64/bullseye/initrd.gz
COPY netboot/images $SERVER_ROOT/images
COPY netboot/system/dnsmasq.conf /etc/
COPY netboot/grub.cfg $SERVER_ROOT/boot/
