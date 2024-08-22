#!/bin/bash
echo "Sourcing params.sh to environment"
ROOTDIR=/home/brandon/work/
echo -e "ROOTDIR:\t $ROOTDIR"
# QUARTUS_DIR="/home/brandon/intelFPGA_pro/24.1/quartus/bin"
QUARTUS_DIR="/home/brandon/intelFPGA/23.1.1std/quartus/bin"
echo -e "QUARTUS_DIR:\t $QUARTUS_DIR"
QSYS_DIR="/home/brandon/intelFPGA_pro/24.1/qsys/bin"
echo -e "QSYS_DIR:\t $QSYS_DIR"
SYSCON_DIR="/home/brandon/intelFPGA_pro/24.1/syscon/bin"
echo -e "system console binary path:\t $SYSCON_DIR"

############ PROJECT PARAMETERS ############
# Quartus PROJECT name
PROJ_NAME=de10_nano
echo -e "Quartus Project Name:\t $PROJ_NAME"

# project setup script name
SETUP_SCRIPT=project_setup.tcl
echo -e "Quartus Project build setup script:\t $SETUP_SCRIPT"

QUARTUS_BUILD_DIR=/home/brandon/quartus_projects/de10_nano
echo -e "Quartus Build Directory:\t $QUARTUS_BUILD_DIR"

# source code directory
SOURCE_CODE_DIR=/home/brandon/work/de10_nano
echo -e "HDL Source code directory:\t $SOURCE_CODE_DIR"


# My custom RTL lib
COMMON_RTL_LIB=/home/brandon/work/hdl_sandbox/rtl_lib
echo -e "Common RTL library location:\t $COMMON_RTL_LIB"
COMMON_TCL_LIB=/home/brandon/work/hdl_sandbox/tcl_lib
echo -e "Common TCL library location:\t $COMMON_TCL_LIB"

# Define hardare targets 
HARDWARE_TARGET=NONE
echo -e "HARDWARE_TARGET:\t $HARDWARE_TARGET"

# Quartus PFG Variables
SOF_DIR=$QUARTUS_BUILD_DIR/output_files
echo -e "SOF_DIR:\t $SOF_DIR"
DTB_FILE=/home/brandon/PON/u-boot-spl-dtb.hex
echo -e "DTB_FILE:\t $DTB_FILE
