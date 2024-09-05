#!/bin/bash
echo "Mount FAT filesystem"
mount /dev/mmcblk01p1 fat/
echo "Copying new FPGA image to partition"
cp sdr.rbf fat/sdr.rbf
echo "Copy complete; cleaning up..."
rm sdr.rbf
umount fat/
./stop_sdram.sh
#echo "Rebooting the system..."
#reboot