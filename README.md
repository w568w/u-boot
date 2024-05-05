# U-Boot for Orange Pi 3B

U-Boot patched for Orange Pi 3B.

Unlikely [Xunlong's U-Boot](https://github.com/orangepi-xunlong/u-boot-orangepi/), this U-Boot is based on the mainline U-Boot, and it is much more up-to-date.

## How to build

Install dependencies:

1. `aarch64-linux-gnu-gcc` toolchain
2. `gcc` toolchain for your host environment

And then:

```bash
$ git clone https://github.com/w568w/u-boot-orangepi-3b --recursive
$ cd u-boot-orangepi-3b
$ ./orangepi-3b-build.sh
```

## How to flash
You only need the built `u-boot-rockchip.bin` file. `#` means you need root permission to execute commands:

```bash
# dd if=u-boot-rockchip.bin of=<your-sd-card> seek=64
# sync
```

Also check [U-Boot's documentation about Rockchip](https://docs.u-boot.org/en/latest/board/rockchip/rockchip.html#flashing).

## Hey, you have fallen behind the mainline U-Boot!
Okay, you can keep up with the mainline by:

```bash
$ git remote add upstream https://github.com/u-boot/u-boot
$ git fetch upstream
$ git merge upstream/master
```

You may need to resolve some conflicts; follow the instructions by Git.