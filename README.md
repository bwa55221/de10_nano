# de10_nano

This repo serves to aid in experimentation with FPGA/HPS bridge structures. It primarily facilities a test space for experimentation with Avalon Streaming and Memory Mapped interfaces and their interaction with user-space. Future use of hardware test vector control from user-space intended. 

Shell scripts have been written to automate most of the kernel build process. This includes modifications for u-boot, custom device tree generation, and creation of the SD card image.

## Build Environment Setup

### Build Essentials
Run the following command to install build dependencies.
```sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev libmpc-dev libgmp3-dev autoconf bc debootstrap qemu-user-static```

### ARM GNU Toolchain / Cross compiler
Available here: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
The latest release at time of writing is ``` 12.3.rel1 ```. 

Download by selecting the zipped tarball for Arch32 GNU/Linux target with hard float (arm-none-linux-gnueabihf):
```arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz```

### u-boot
Found here: https://github.com/u-boot/u-boot
This build used the branch ``` master ``` with tag ``` v2023.10-rc1 ```.

### Root Filesystem
``` deboostrap ``` and ``` qemu ``` are used to install the rootfs into a subdirectory and modify for our build.
At time of writing, the latest Debian version is ``` bookworm ```.

Install with ``` sudo debootstrap --arch=armhf --foreign bookworm rootfs ```. More details here: https://github.com/zangman/de10-nano/blob/master/docs/Debian-Root-File-System.md

## Build Notes

Users should add the following lines to their ~/.bashrc file.

### setup alias for DE10-Nano FPGA working directory
```
export DEWD=/home/<username>/DE10_wrk
```

### Cross compiler for DE10 Nano
```
export CROSS_COMPILE=/home/<username>/DE10_wrk/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-
```
## Disclaimer
Initial setup code based off of tutorial, here: https://github.com/zangman/de10-nano
