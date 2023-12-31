# de10_nano

This repo serves to aid in experimentation with FPGA/HPS bridge structures. It primarily facilities a test space for experimentation with Avalon Streaming and Memory Mapped interfaces and their interaction with user-space. Future use of hardware test vector control from user-space intended. 

Shell scripts have been written to automate most of the kernel build process. This includes modifications for u-boot, custom device tree generation, and creation of the SD card image.

## Build Environment Setup

### Build Essentials
Run the following command to install build dependencies.
```sudo apt-get install libncurses-dev flex bison openssl libssl-dev dkms libelf-dev libudev-dev libpci-dev libiberty-dev libmpc-dev libgmp3-dev autoconf bc debootstrap qemu-user-static```

### Clone this repository
In my case, this repository was cloned to my home directory.
```git clone git@github.com:bwa55221/de10_nano.git```

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

### Download the Linux Kernel
Clone the Altera Linux Repository.
```
cd $DEWD
git clone https://github.com/altera-opensource/linux-socfpga.git
```
Find a branch that we want to use:
```
cd linux-socfpga
git branch -a
git checkout socfpga-6.1.38-lts
```
Initialize the configuration for the target (DE10-Nano):
```
make ARCH=arm socfpga_defconfig
```
Now open the kernel configuration menu:
```
make ARCH=arm menuconfig
```

Make sure to do the following in the kernel configuration menu:
* Under File Systems, Enable ```Overlay filesystem support``` (and all options under its heading)
* Uncheck ```Automatically append version information to the version string```, this is in General Setup
* Enable CONFIGFS if not already enabled, this is under File Systems -> Pseudo Filesystems
Save and exit when done.

Now compile the kernel with:
```
make ARCH=arm LOCALVERSION=zImage -j 24
```

### Configure Device Tree
The default device tree can be found here:
```
cd $DEWD/linux-socfpga/arch/arm/boot/dts/socfpga.dtsi
```
Inspection of the default device tree shows that the FPGA/HPS bridges are disabled. 

Create a custom child device tree file to enable the FPGA/HPS bridges we want to use. 
```
cp socfpga_cyclone5_de0_nano_soc.dts my_custom.dts
```
Modify ```my_custom.dts``` as needed. 

I have placed an already modified device tree file in ~/de10_nano/device_tree.

Create the device tree blob by running the generation script from this repo:
```
./generate_dtb.sh
```


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
Make u-boot by running the u-boot generation script in this repository. This script updates the u-boot configuration with modifications to ```config_distro_bootcmd.h``` that allow the system to load the FPGA image from the FAT partition at boot time. This script also copies over the modified socfpga_common.h file. The modifications to this file configure a hardcoded MAC address.
```
cd ~/de10_nano/u-boot
./generate_uboot.sh
```

### Root Filesystem
``` deboostrap ``` and ``` qemu ``` are used to install the rootfs into a subdirectory and modify for our build.
At time of writing, the latest Debian version is ``` bookworm ```.

Install with 
```
cd $DEWD
sudo debootstrap --arch=armhf --foreign bookworm rootfs
sudo cp /usr/bin/qemu-arm-static rootfs/usr/bin/
```
Now can ```chroot```:
```
sudo chroot rootfs /usr/bin/qemu-arm-static /bin/bash -i
```

Kick off the second stage of ```debootstrap```:
```
/debootstrap/debootstrap --second-stage
```
Wait for this to complete. 

Now we can run the configuration script which installs packages and configures the rootfs for usability:
```
cd ~/de10_nano
./configure_rootfs.sh
```

Create rootfs tarball for adding to system image:
```
cd $DEWD/rootfs
sudo tar -cjpf $DEWD/rootfs.tar.bz2 .
```

### Copy FPGA .sof file to Work Directory
Copy desired FPGA image to the work directory.

### Create SD Card Image
Update the SD card image generation script with the filename of the FPGA load. The SD card image generation script is located in the top level of this repo:
```
~/de10_nano/create_sdcard_image.sh
```

Insert an SD Card into the build maching and run the script for writing the SD card image:
```
./write_sdcard.sh
```

Enjoy!

## Disclaimer
Initial setup code based off of tutorial, here: https://github.com/zangman/de10-nano
