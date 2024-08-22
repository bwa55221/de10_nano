source /home/brandon/work/hdl_sandbox/tcl_lib/readfile.tcl
readfile parameters.sh

# note: the overwrite flag overwrites any .qsf if it exists
project_new ${PROJ_NAME} -overwrite 

set_global_assignment -name TOP_LEVEL_ENTITY system_top_level
set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 100
set_global_assignment -name VHDL_INPUT_VERSION VHDL_2008
set_global_assignment -name VERILOG_INPUT_VERSION SYSTEMVERILOG_2012
set_global_assignment -name NUM_PARALLEL_PROCESSORS ALL
set_global_assignment -name SEED 1
set_global_assignment -name FLOW_ENABLE_RTL_VIEWER ON
set_global_assignment -name HDL_MESSAGE_LEVEL LEVEL3
set_global_assignment -name REMOVE_DUPLICATE_REGISTERS OFF
set_global_assignment -name SYNTH_PROTECT_SDC_CONSTRAINT ON


####################################################################################
################################# ADD FILES ########################################
####################################################################################

#set_global_assignment -name GENERATE_COMPRESSED_SOF ON
set_global_assignment -name SDC_FILE "${SOURCE_CODE_DIR}/${PROJ_NAME}.sdc"
#set_global_assignment -name VHDL_FILE "${SOURCE_CODE_DIR}/hdl/pcie_sys_top_level.vhd"
#set_global_assignment -name VERILOG_FILE "${DMA_MODULE_DIR}/pcie_dma_mod.v"
set_global_assignment -name SYSTEMVERILOG_FILE "${SOURCE_CODE_DIR}/hdl/system_top_level.sv"
#set_global_assignment -name QSYS_FILE "${SOURCE_CODE_DIR}/synthesis/pcie_sys.qsys"
#set_global_assignment -name IP_FILE "${SOURCE_CODE_DIR}/synthesis/ip/rtk_clock_bridge.ip"

# add date code vhdl
source ${COMMON_TCL_LIB}/datetime.tcl
set_global_assignment -name VHDL_FILE "${COMMON_RTL_LIB}/datetime_driver.vhd"
set_global_assignment -name VHDL_FILE "${COMMON_RTL_LIB}/datetime.vhd"


####################################################################################
########################### Signal Tap & Debug #####################################
####################################################################################

# set_global_assignment -name ENABLE_SIGNALTAP ON
# set_global_assignment -name USE_SIGNALTAP_FILE "${SOURCE_CODE_DIR}/stp1.stp"
# set_global_assignment -name SIGNALTAP_FILE "${SOURCE_CODE_DIR}/stp1.stp"
# set_global_assignment -name PRESERVE_FOR_DEBUG_ENABLE ON

####################################################################################
############################## Virtual Pins ########################################
####################################################################################

# this is needed so the design elements aren't synthesized out. 

# set_instance_assignment -name VIRTUAL_PIN ON -to ul_start_bit				

# set_global_assignment -name PRESERVE_FOR_DEBUG_ENABLE ON
# set_global_assignment -name REMOVE_DUPLICATE_REGISTERS OFF
# set_global_assignment -name ALLOW_ANY_RAM_SIZE_FOR_RECOGNITION ON

####################################################################################
########################### ADDITIONAL SDM SETTINGS ################################
####################################################################################

# set_global_assignment -name AUTO_RESTART_CONFIGURATION OFF
# set_global_assignment -name USE_CVP_CONFDONE SDM_IO10
# set_global_assignment -name DEVICE_INITIALIZATION_CLOCK OSC_CLK_1_125MHZ
# set_global_assignment -name PWRMGT_PAGE_COMMAND_ENABLE OFF
# set_global_assignment -name PWRMGT_VOLTAGE_OUTPUT_FORMAT "LINEAR FORMAT"
# set_global_assignment -name PWRMGT_LINEAR_FORMAT_N "-13"
# set_global_assignment -name USE_INIT_DONE SDM_IO0
# set_global_assignment -name POWER_APPLY_THERMAL_MARGIN ADDITIONAL

####################################################################################
####################################################################################
########################## PIN ASSIGNMENTS FROM GHRD ###############################
####################################################################################
####################################################################################


####################################################################################
####################################################################################
########################## END ASSIGNMENTS FROM GHRD ###############################
####################################################################################
####################################################################################

project_close

