#!/bin/sh

OK="[OK]"
NOK="[NOK]"
LOG=$(mktemp)

dmesg > $LOG

echo "Hardware"
echo -ne "  Machine (Lichee Pi Nano)\t"
if grep -q "CPU: ARM926EJ-S" $LOG &&
   grep -q "Machine model: Lichee Pi Nano" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  Memory (32768 Kbytes)\t\t"
if grep -q "/32768K available" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  UART (ttyS0)\t\t\t"
if [ -c /dev/ttyS0 ] &&
   grep -q "1c25000.serial: ttyS0 at MMIO 0x1c25000" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  SPI (xt25f128b 16384 Kbytes)\t"
if grep -q "m25p80 spi0.0: xt25f128b (16384 Kbytes)" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  Pinctrl\t\t\t"
if grep -q "suniv-pinctrl 1c20800.pinctrl: initialized sunXi PIO driver" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  MMC\t\t\t\t"
if grep -q "sunxi-mmc 1c0f000.mmc" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  I2C\t\t\t\t"
if [ -c "/dev/i2c-0" ] &&
   grep -q "i2c /dev entries driver" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  PCA9685 PWM on I2C\t\t"
#echo 0 > /sys/class/pwm/pwmchip0/export
#echo 0 > /sys/class/pwm/pwmchip0/unexport
#if [ ! dmesg | grep -v -q "i2c i2c-0: mv64xxx: I2C bus locked" ] &&
#   grep -q pca9685-pwm /sys/class/pwm/pwmchip0/device/name; then
if grep -q pca9685-pwm /sys/class/pwm/pwmchip0/device/name &&
   ! dmesg | grep -q "i2c i2c-0: mv64xxx: I2C bus locked" ; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  USB phy and hub\t\t"
if grep -q "usb_phy_generic usb_phy_generic.0.auto" $LOG &&
   grep -q "musb-hdrc musb-hdrc.1.auto: MUSB HDRC host driver" $LOG &&
   grep -q "hub 1-0:1.0: USB hub found" $LOG &&
   lsusb | grep -q "Bus 001 Device 001: ID 1d6b:0002"; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  Display backend\t\t"
if grep -q "sun4i-drm display-engine: bound 1e60000.display-backend" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  LCD controller\t\t"
if grep -q "sun4i-drm display-engine: bound 1c0c000.lcd-controller" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  Frame buffer\t\t\t"
if [ -c /dev/fb0 ] &&
  grep -q "sun4i-drm display-engine: fb0: DRM emulated frame buffer device" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo "Configuration"
echo -ne "  SPI partitions\t\t"
if grep -q "\"u-boot\"" $LOG &&
   grep -q "\"dtb\"" $LOG &&
   grep -q "\"kernel\"" $LOG &&
   grep -q "\"rootfs\"" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  GPIO\t\t\t\t"
if [ -d /sys/class/gpio/gpiochip0 ]; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  ESP8089 WiFi module\t\t"
if [ -f /lib/firmware/eagle_fw_first_init_v19.bin ] &&
  lsmod | grep -q "esp8089"; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  /proc/config.gz\t\t"
if [ -f /proc/config.gz ]; then
  echo $OK
else
  echo $NOK
fi

echo "Network"
echo -ne "  usb0\t\t\t\t"
if ip a | grep -q "usb0" $LOG; then
  echo $OK
else
  echo $NOK
fi

echo -ne "  wlan0\t\t\t\t"
if ip a | grep -q "wlan0" $LOG; then
  echo $OK
else
  echo $NOK
fi
