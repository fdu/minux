dir_work = work
dir_src = src
dir_overlay = overlay
dir_output = output
dir_downloads = $(dir_work)/downloads
dir_buildroot = $(dir_work)/buildroot
dir_configs = $(dir_src)/configs
dir_patches = $(dir_src)/patches
dir_firmware = $(dir_overlay)/lib/firmware

patch_f1c100_drivers = $(dir_work)/patches/linux/0001-f1c100-drivers.patch
patch_esp8089 = $(dir_work)/patches/linux/0002-esp8089.patch

archive_buildroot = buildroot.tar.gz
archive_kernel_vanilla = kernel_vanilla.tar.gz
archive_kernel_3rdparty = kernel_3rdparty.tar.gz
archive_esp8089 = esp8089.tar.gz

url_buildroot = https://buildroot.org/downloads/buildroot-2020.02.8.tar.gz
url_kernel_vanilla = https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.1.tar.xz
url_kernel_3rdparty = https://github.com/suda-morris/suda-f1c100s/tarball/95c281e53eac7c5658ee306141494bddac67d8be
url_esp8089 = https://github.com/Icenowy/esp8089/tarball/71c53ead1ce24fb5cee1f9c2eb251be1f3125e37
url_fel-sdboot = https://raw.githubusercontent.com/linux-sunxi/sunxi-tools/master/bin/fel-sdboot.sunxi

all: $(dir_output)/flash.bin $(dir_output)/sunxi-fel $(dir_output)/fel-sdboot.sunxi
	

flash: $(dir_output)/flash.bin $(dir_output)/sunxi-fel
	$(dir_output)/sunxi-fel -p spiflash-write 0 $(dir_output)/flash.bin

$(dir_output)/fel-sdboot.sunxi:
	mkdir -p $(dir_output)
	curl -L $(url_fel-sdboot) > $@
	touch $@

$(dir_output)/flash.bin: $(dir_buildroot)/output/images/flash.bin
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/images/flash.bin $@

$(dir_output)/sunxi-fel: $(dir_buildroot)/output/host/bin/sunxi-fel
	mkdir -p $(dir_output)
	cp $(dir_buildroot)/output/host/bin/sunxi-fel $@

$(dir_firmware): $(dir_downloads)/$(archive_esp8089)
	mkdir -p $(dir_overlay)/lib/firmware
	tar xf $(dir_downloads)/$(archive_esp8089) --strip-components=2 -C $(dir_overlay)/lib/firmware Icenowy-esp8089-71c53ea/firmware

$(patch_esp8089): $(dir_downloads)/$(archive_kernel_vanilla) $(dir_downloads)/$(archive_esp8089)
	mkdir -p $(dir_work)/patches/linux
	mkdir -p $(dir_work)/kernel_vanilla
	mkdir -p $(dir_work)/kernel_patching
	tar xf $(dir_downloads)/$(archive_kernel_vanilla) --strip-components=1 -C $(dir_work)/kernel_vanilla
	tar xf $(dir_downloads)/$(archive_kernel_vanilla) --strip-components=1 -C $(dir_work)/kernel_patching
	mkdir -p $(dir_work)/kernel_patching/drivers/staging/esp8089
	tar xf $(dir_downloads)/$(archive_esp8089) --strip-components=1 -C $(dir_work)/kernel_patching/drivers/staging/esp8089
	echo 'obj-$$(CONFIG_ESP8089)           += esp8089/' >> $(dir_work)/kernel_patching/drivers/staging/Makefile
	head -n -1 $(dir_work)/kernel_patching/drivers/staging/Kconfig > $(dir_work)/kernel_patching/drivers/staging/Kconfig.new
	mv $(dir_work)/kernel_patching/drivers/staging/Kconfig.new $(dir_work)/kernel_patching/drivers/staging/Kconfig
	echo 'source "drivers/staging/esp8089/Kconfig"' >> $(dir_work)/kernel_patching/drivers/staging/Kconfig
	echo 'endif # STAGING' >> $(dir_work)/kernel_patching/drivers/staging/Kconfig
	cd $(dir_work)/kernel_patching && git diff --no-index ../kernel_vanilla/drivers/staging/ drivers/staging/ > ../../$@ || true
	rm -rf $(dir_work)/kernel_vanilla
	rm -rf $(dir_work)/kernel_patching

$(patch_f1c100_drivers): $(dir_downloads)/$(archive_kernel_vanilla) $(dir_downloads)/$(archive_kernel_3rdparty)
	mkdir -p $(dir_work)/patches/linux
	mkdir -p $(dir_work)/kernel_vanilla
	mkdir -p $(dir_work)/kernel_patching
	tar xf $(dir_downloads)/$(archive_kernel_vanilla) --strip-components=1 -C $(dir_work)/kernel_vanilla
	tar xf $(dir_downloads)/$(archive_kernel_vanilla) --strip-components=1 -C $(dir_work)/kernel_patching
	tar zxf $(dir_downloads)/$(archive_kernel_3rdparty) --strip-components=3 -C $(dir_work)/kernel_patching/ suda-morris-suda-f1c100s-95c281e/kernel/linux-4.19.1
	cp $(dir_work)/kernel_vanilla/drivers/video/logo/logo_linux_clut224.ppm $(dir_work)/kernel_patching/drivers/video/logo/
	cd $(dir_work)/kernel_patching && git diff --no-index ../kernel_vanilla/ . > ../../$@ || true
	rm -rf $(dir_work)/kernel_vanilla
	rm -rf $(dir_work)/kernel_patching

$(dir_downloads)/$(archive_esp8089):
	mkdir -p $(dir_downloads)
	curl -L $(url_esp8089) > $@
	touch $@

$(dir_downloads)/$(archive_kernel_vanilla):
	mkdir -p $(dir_downloads)
	curl -L $(url_kernel_vanilla) > $@
	touch $@

$(dir_downloads)/$(archive_kernel_3rdparty):
	mkdir -p $(dir_downloads)
	curl -L $(url_kernel_3rdparty) > $@
	touch $@

$(dir_buildroot)/output/images/flash.bin: $(patch_f1c100_drivers) $(patch_esp8089) $(dir_buildroot) $(dir_buildroot)/.config $(dir_firmware)
	$(MAKE) -j`nproc` -C $(dir_buildroot)

$(dir_downloads)/$(archive_buildroot):
	mkdir -p $(dir_downloads)
	curl $(url_buildroot) > $@
	touch $@

$(dir_buildroot): $(dir_downloads)/$(archive_buildroot)
	mkdir -p $@
	tar zxf $< -C $@ --strip-components=1
	patch -d $(dir_buildroot) -p1 < $(dir_patches)/buildroot/sunxi-tools/0001-sunxi-tools-spiflash.patch

$(dir_buildroot)/.config:
	ln -sf `pwd`/$(dir_configs)/buildroot $@

clean:
	rm -rf $(dir_work) $(dir_output) $(dir_firmware)
