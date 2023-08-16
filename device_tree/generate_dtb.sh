#!/bin/bash

# move custom device tree overlay to build directory
cp custom.dts ${DEWD}/linux-socfpga/arch/arm/boot/dts/.

cd ${DEWD}/linux-socfpga

make ARCH=arm custom.dtb
echo "Compiled custom.dtb"

