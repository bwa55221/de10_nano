#!/bin/bash

source parameters.sh
# PROJ_NAME=development
# SOF_DIR=/home/brandon/quartus_projects/xgs_olt/development/output_files
# DTB_FILE=/home/brandon/PON/u-boot-spl-dtb.hex

# echo "Removing the old .sof"
# rm XPON_fpga.sof
# echo "Removing the old hps.sof"
# rm XPON_fpga_hps.sof
# echo "Copying the new .sof to local directory"
# cp ~/quartus_projects/xgspon_fpga/sw_test_proj/sw_test_proj.sof XPON_fpga.sof
# echo "Generating the new hps.sof"
$QUARTUS_DIR/quartus_pfg -c -o hps_path=$DTB_FILE "$SOF_DIR/$PROJ_NAME.sof" "$SOF_DIR/${PROJ_NAME}_hps.sof"

