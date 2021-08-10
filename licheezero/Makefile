dir_work = work
dir_src = src
dir_overlay = overlay
dir_output = output
dir_downloads = $(dir_work)/downloads
dir_buildroot = $(dir_work)/buildroot
dir_configs = $(dir_src)/configs
dir_patches = $(dir_src)/patches
archive_buildroot = buildroot.tar.gz
url_buildroot = https://buildroot.org/downloads/buildroot-2021.02.3.tar.bz2

all: $(dir_output)/u-boot-sunxi-with-spl.bin $(dir_output)/sun8i-v3s-licheepi-zero-dock.dtb $(dir_output)/zImage $(dir_output)/boot.scr $(dir_output)/rootfs.tar
	

$(dir_output)/u-boot-sunxi-with-spl.bin: $(dir_buildroot)/output/images/u-boot-sunxi-with-spl.bin
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/u-boot-sunxi-with-spl.bin $@

$(dir_output)/sun8i-v3s-licheepi-zero-dock.dtb: $(dir_buildroot)/output/images/sun8i-v3s-licheepi-zero-dock.dtb
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/sun8i-v3s-licheepi-zero-dock.dtb $@

$(dir_output)/zImage: $(dir_buildroot)/output/images/zImage
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/zImage $@

$(dir_output)/boot.scr: $(dir_buildroot)/output/images/boot.scr
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/boot.scr $@

$(dir_output)/rootfs.tar: $(dir_buildroot)/output/images/rootfs.tar
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/rootfs.tar $@

$(dir_buildroot)/output/images/u-boot-sunxi-with-spl.bin: $(dir_buildroot) $(dir_buildroot)/.config
	$(MAKE) -j`nproc` -C $(dir_buildroot)

$(dir_buildroot)/output/images/sun8i-v3s-licheepi-zero-dock.dtb: $(dir_buildroot) $(dir_buildroot)/.config
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
