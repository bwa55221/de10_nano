#!/bin/bash

# this script generates the u-boot-with-spl.sfp file 

cd ${DEWD}/u-boot

# preare the default configuration for u-boot
make ARCH=arm socfpga_de10_nano_defconfig

# call this to fine tune the configuration
#make ARCH=arm menuconfig

# build u-boot
make ARCH=arm -j 24


