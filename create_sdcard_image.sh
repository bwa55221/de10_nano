#!/bin/bash

cd $DEWD

# create directory for sdcard
if [ -d ${DEWD}/sdcard ]
then
echo "sdcard directory already exists, removing..."
sudo rm -r sdcard
fi

# create new sdcard directory
sudo mkdir sdcard

# go into sdcard directory
cd sdcard

# Create an image file of 1GB in size.
sudo dd if=/dev/zero of=sdcard.img bs=1G count=6

# make image visible as a disk drive
IMAGE_FILE=$(sudo losetup --show -f sdcard.img)
echo "${IMAGE_FILE} now visible as disk drive."

# Partition the sdcard image
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk ${IMAGE_FILE}
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  3 # partition number 1
    # default - start at beginning of disk 
  +1M # 100 MB boot parttion
  t
  a2
  n # new partition
  p # primary partition
  1 # partion number 2
    # default, start immediately after preceding partition
  +254M # default, extend partition to end of disk
  t # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  b # print the in-memory partition table
  n
  p
  2
  

  w # write the partition table
  q # and we're done
EOF

# enable partition mount for access R/W
sudo partprobe ${IMAGE_FILE}

#### create filesystems ####
# Partition 1 is FAT
sudo mkfs -t vfat ${IMAGE_FILE}p1

# Partition 2 is Linux
sudo mkfs.ext4 ${IMAGE_FILE}p2

# Parition 3 is Bootloader
sudo dd if=/dev/zero of=${IMAGE_FILE}p3 bs=64k oflag=sync status=progress
sudo dd if=../u-boot/u-boot-with-spl.sfp of=${IMAGE_FILE}p3 bs=64k seek=0 oflag=sync

#### Kernel and Device Tree Partition ####
sudo mkdir -p fat
# mount the fat partition
sudo mount ${IMAGE_FILE}p1 fat

# copy the kernel image
sudo cp ../linux-socfpga/arch/arm/boot/zImage fat

# copy the device tree
sudo cp ../linux-socfpga/arch/arm/boot/dts/custom.dtb fat

# copy the fpga image as "soc_system.rbf"
sudo cp ../custom_fpga_load.rbf fat/soc_system.rbf

#### Create the extlinux config file for the bootloader. ####
echo "LABEL Linux Default" | sudo tee -a extlinux.conf
echo "    KERNEL ../zImage" | sudo tee -a extlinux.conf
echo "    FDT ../custom.dtb" | sudo tee -a extlinux.conf
echo "    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8" | sudo tee -a extlinux.conf

# Copy it into the extlinux folder.
sudo mkdir -p fat/extlinux
sudo cp extlinux.conf fat/extlinux

# Unmount the partition.
sudo umount fat

#### Make rootfs partition ####
sudo mkdir -p ext4

# Mount the ext4 partition.
sudo mount ${IMAGE_FILE}p2 ext4

# Extract the rootfs archive.
cd ext4
sudo tar -xf $DEWD/rootfs.tar.bz2

# Unmount the partition.
cd ..
sudo umount ext4

#### Cleanup ####
# Delete unnecessary files and folders.
cd $DEWD
cd sdcard
sudo rmdir fat
sudo rmdir ext4
sudo rm extlinux.conf

# Delete the loopback device.
sudo losetup -d ${IMAGE_FILE}





