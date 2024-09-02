#!/bin/bash

FILES="h2f_rw/imload
image_conversion/raw_image.raw
check_sdram.sh
stop_sdram.sh"

for f in $FILES
do
    echo "Copying $f to target"
    scp $f root@192.168.1.19:/root/.
done

