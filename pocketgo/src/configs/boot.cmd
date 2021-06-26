setenv bootargs console=ttyS1,115200 console=tty0 panic=10 rootwait root=/dev/mmcblk0p2 rw fbcon=rotate:2
load mmc 0:1 0x80C00000 suniv-f1c500s-miyoo.dtb
load mmc 0:1 0x80008000 zImage
bootz 0x80008000 - 0x80C00000
