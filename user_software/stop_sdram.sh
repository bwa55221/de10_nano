#!/bin/bash

# alias mem='busybox devmem'
echo "Sending stop transfer command to SDRAM CTRL Regsiters..."
busybox devmem 0xC0000000 32 0x00000000
