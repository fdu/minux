#!/bin/sh

make -C buildroot_amd64 -j`nproc`
mkdir -p /images/amd64/buildroot/
cp /buildroot_amd64/output/images/* /images/amd64/buildroot/
make -C buildroot_arm64 -j`nproc`
mkdir -p /images/arm64/buildroot/
cp /buildroot_arm64/output/images/* /images/arm64/buildroot/
