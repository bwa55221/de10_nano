#!/bin/bash

# This needs to be done after editing the rootfs, and run before creating the new sdcard image

cd $DEWD
cd rootfs

sudo tar -cjpf $DEWD/rootfs.tar.bz2 .

cd ..