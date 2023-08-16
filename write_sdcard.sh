#!/bin/bash

cd $DEWD
cd sdcard

lsblk

echo "Enter device (Ex: /dev/sdb):"
read device
echo "Selected device ${device}"

# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can 
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo fdisk ${device}

  d # delete partition 1
    # continue
  d # delete partition 2
    # continue
  d # delete partition 3
    # continue
  w # write to disk
  q # quite
EOF

### write image to disk ###
sudo dd if=sdcard.img of=$device bs=64K status=progress
