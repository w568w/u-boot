#!/bin/bash

rm --recursive --force out
cp --recursive rkbin /tmp 

# setup your build target here!
readonly RK_BOOT_INI=RKBOOT/RK3566MINIALL.ini # relative to ./rkbin
readonly RK_TRUST_INI=RKTRUST/RK3568TRUST.ini # relative to ./rkbin
readonly RK_BL31=bin/rk35/rk3568_bl31_v1.43.elf # relative to ./rkbin, need to be changed according to rkbin repo
readonly BOARD_CONFIG_NAME=orangepi-3b-rk3566_defconfig

# read TPL and BL31 from BOOT_INI
RK_ROCKCHIP_TPL=$(grep --only-matching --perl-regexp '(?<==).*\.bin' rkbin/"$RK_BOOT_INI" | grep "ddr" | head --lines=1)
readonly RK_ROCKCHIP_TPL
RK_LOADER_OUTPUT=$(grep --only-matching --perl-regexp '(?<=PATH=).*' rkbin/"$RK_BOOT_INI" | head --lines=1)
readonly RK_LOADER_OUTPUT
RK_TRUST_OUTPUT=$(grep --only-matching --perl-regexp '(?<=PATH=).*' rkbin/"$RK_TRUST_INI" | head --lines=1)
readonly RK_TRUST_OUTPUT

# build u-boot
export ROCKCHIP_TPL=/tmp/rkbin/"$RK_ROCKCHIP_TPL"
export BL31=/tmp/rkbin/"$RK_BL31"
make CROSS_COMPILE=aarch64-linux-gnu- "$BOARD_CONFIG_NAME"
make CROSS_COMPILE=aarch64-linux-gnu- --jobs="$(nproc)" all
unset ROCKCHIP_TPL
unset BL31

# build MiniLoaderAll.bin and trust.img
pushd /tmp/rkbin || exit 1
tools/boot_merger "$RK_BOOT_INI"
tools/trust_merger "$RK_TRUST_INI"
popd || exit 1

mkdir --parents out
mv /tmp/rkbin/"$RK_TRUST_OUTPUT" out/trust.img # need to be changed according to RKTRUST/RK3568TRUST.ini
mv /tmp/rkbin/"$RK_LOADER_OUTPUT" out/MiniLoaderAll.bin # need to be changed according to RKBOOT/RK3566MINIALL.ini
mv u-boot.img out/u-boot.img

rm --recursive --force /tmp/rkbin