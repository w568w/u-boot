#!/bin/bash

make mrproper
cp --recursive rkbin /tmp 
# Rockchip's proprietary TPL to initialize the DRAM
export ROCKCHIP_TPL=/tmp/rkbin/bin/rk35/rk3566_ddr_1056MHz_v1.21.bin
# Rockchip's proprietary TF-A to initialize the secure environment
export BL31=/tmp/rkbin/bin/rk35/rk3568_bl31_v1.44.elf
make CROSS_COMPILE=aarch64-linux-gnu- orangepi-3b-rk3566_defconfig
make CROSS_COMPILE=aarch64-linux-gnu- --jobs all
rm --recursive --force /tmp/rkbin