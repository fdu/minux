#!/bin/sh

PWM=7

if [ ! -d /sys/class/pwm/pwm$PWM ]; then
  echo $PWM > /sys/class/pwm/pwmchip0/export
fi

if [ ${1:-1} == 1 ]; then
  echo 1000000 > /sys/class/pwm/pwmchip0/pwm$PWM/period
  echo 500000 > /sys/class/pwm/pwmchip0/pwm$PWM/duty_cycle
  echo ${1:-1} > /sys/class/pwm/pwmchip0/pwm$PWM/enable
else
  echo 0 > /sys/class/pwm/pwmchip0/pwm$PWM/duty_cycle
fi
