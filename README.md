# de10_nano

This repo serves to aid in experimentation with FPGA/HPS bridge structures. It primarily facilities a test space for experimentation with Avalon Streaming and Memory Mapped interfaces and their interaction with user-space. Future use of hardware test vector control from user-space intended. 

Shell scripts have been written to automate most of the kernel build process. This includes modifications for u-boot, custom device tree generation, and creation of the SD card image.

## Build Environment Setup

### Build Essentials
Run the following command to install build dependencies.
```sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev libmpc-dev libgmp3-dev autoconf bc debootstrap qemu-user-static```

### Make a work directory
```mkdir ~/de10_work```

### Modify .bashrc
Users should add the following lines to their ~/.bashrc file. This creates system environment variables that link to the work directory and to the cross-compiler toolchain.
```
export DEWD=/home/<username>/de10_work
```
```
export CROSS_COMPILE=/home/<username>/de10_work/arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf/bin/arm-none-linux-gnueabihf-
```

### Get the ARM GNU Toolchain / Cross compiler
Available here: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
The latest release at time of writing is ``` 12.3.rel1 ```. 

Download by selecting the zipped tarball for Arch32 GNU/Linux target with hard float (arm-none-linux-gnueabihf):
```arm-gnu-toolchain-12.3.rel1-x86_64-arm-none-linux-gnueabihf.tar.xz```

Extract this into the work directory.

### Download u-boot
Found here: https://github.com/u-boot/u-boot or here https://github.com/altera-opensource/u-boot-socfpga. I will use the Altera SOCFPGA u-boot.
I used the default branch ```socfpga_v2023.04```.

Change to work directory
```
cd $DEWD
```
Clone the u-boot repository with
```
git clone git@github.com:altera-opensource/u-boot-socfpga.git
```


### Root Filesystem
``` deboostrap ``` and ``` qemu ``` are used to install the rootfs into a subdirectory and modify for our build.
At time of writing, the latest Debian version is ``` bookworm ```.

Install with ``` sudo debootstrap --arch=armhf --foreign bookworm rootfs ```. More details here: https://github.com/zangman/de10-nano/blob/master/docs/Debian-Root-File-System.md

## Disclaimer
Initial setup code based off of tutorial, here: https://github.com/zangman/de10-nano
