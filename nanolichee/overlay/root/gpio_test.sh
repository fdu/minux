#!/bin/sh

GPIO=3

if [ ! -d /sys/class/gpio/gpio$GPIO ]; then
  echo $GPIO > /sys/class/gpio/export
fi
echo out > /sys/class/gpio/gpio$GPIO/direction
echo ${1:-1} > /sys/class/gpio/gpio$GPIO/value
