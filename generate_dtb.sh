#!/bin/bash

cd ${DEWD}/linux-socfpga

make ARCH=arm custom.dtb
echo "Compiled custom.dtb"

