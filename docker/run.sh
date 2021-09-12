#!/bin/sh

docker build . -t minux-buildroot -f buildroot/Dockerfile
docker run -it --rm -v `pwd`/netboot/images:/images minux-buildroot
docker build . -t minux-netboot -f netboot/Dockerfile
docker run -it --rm --net=host --cap-add=NET_ADMIN -e NIC=eth1 minux-netboot
