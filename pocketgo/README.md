 - Create partition 1 on SD card of 16 MB and format in FAT 32
 - Create partition 2 on SD card and format in FAT 32
 - Copy output/boot.scr, output/suniv-f1c500s-miyoo.dtb and output/zImage to partition 1
 - Extract output/rootfs.tar to partition 2
 - Copy U-Boot to the SD card: dd if=output/u-boot.bin of=/dev/mmcblk0 bs=1024 seek=8