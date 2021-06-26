dir_work = work
dir_src = src
dir_overlay = overlay
dir_output = output
dir_downloads = $(dir_work)/downloads
dir_buildroot = $(dir_work)/buildroot
dir_configs = $(dir_src)/configs
dir_patches = $(dir_src)/patches
archive_buildroot = buildroot.tar.gz
url_buildroot = https://buildroot.org/downloads/buildroot-2018.02.9.tar.bz2
url_uboot = https://github.com/MiyooCFW/mainboot/raw/master/boot/misc/u-boot-bins/u-boot-v90_q90_pocketgo.bin

all: $(dir_output)/u-boot.bin $(dir_output)/suniv-f1c500s-miyoo.dtb $(dir_output)/zImage $(dir_output)/boot.scr $(dir_output)/rootfs.tar
	

$(dir_output)/u-boot.bin:
	mkdir -p $(dir_output)
	curl $(url_uboot) > $@

$(dir_output)/suniv-f1c500s-miyoo.dtb: $(dir_buildroot)/output/images/suniv-f1c500s-miyoo.dtb
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/suniv-f1c500s-miyoo.dtb $@

$(dir_output)/zImage: $(dir_buildroot)/output/images/zImage
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/zImage $@

$(dir_output)/boot.scr: $(dir_buildroot)/output/images/boot.scr
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/boot.scr $@

$(dir_output)/rootfs.tar: $(dir_buildroot)/output/images/rootfs.tar
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/rootfs.tar $@

$(dir_buildroot)/output/images/suniv-f1c500s-miyoo.dtb: $(dir_buildroot) $(dir_buildroot)/.config
	$(MAKE) -j`nproc` -C $(dir_buildroot)

$(dir_buildroot)/output/images/zImage: $(dir_buildroot) $(dir_buildroot)/.config
	$(MAKE) -j`nproc` -C $(dir_buildroot)

$(dir_buildroot)/output/images/boot.scr: $(dir_buildroot) $(dir_buildroot)/.config
	$(MAKE) -j`nproc` -C $(dir_buildroot)

$(dir_buildroot)/output/images/rootfs.tar: $(dir_buildroot) $(dir_buildroot)/.config
	$(MAKE) -j`nproc` -C $(dir_buildroot)

$(dir_downloads)/$(archive_buildroot):
	mkdir -p $(dir_downloads)
	curl $(url_buildroot) > $@
	touch $@

$(dir_buildroot): $(dir_downloads)/$(archive_buildroot)
	mkdir -p $@
	tar xf $< -C $@ --strip-components=1

$(dir_buildroot)/.config:
	ln -sf `pwd`/$(dir_configs)/buildroot $@

clean:
	rm -rf $(dir_work) $(dir_output) $(dir_firmware)
