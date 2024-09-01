#!/bin/bash

# this script generates the u-boot-with-spl.sfp file 

# copy DE10 nano customized files to u-boot build directory
sudo cp socfpga_common.h ${DEWD}/u-boot-socfpga/include/configs/.
sudo cp config_distro_bootcmd.h ${DEWD}/u-boot-socfpga/include/.

cd ${DEWD}/u-boot-socfpga

# preare the default configuration for u-boot
make ARCH=arm socfpga_de10_nano_defconfig

# call this to fine tune the configuration
# make ARCH=arm menuconfig

# build u-boot
make ARCH=arm -j 24


