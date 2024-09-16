#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************

create_clock -period 20 [get_ports FPGA_CLK1_50]
create_clock -period 20 [get_ports FPGA_CLK2_50]
create_clock -period 20 [get_ports FPGA_CLK3_50]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
# signal tap nodes (not sure why?)
set_false_path -from {hdmi_pixel_driver:hdmi_pixel_driver|pixfifo_req_o} -to {sld_signaltap:auto_signaltap_0|acq_trigger_in_reg[20]}
set_false_path -from {hdmi_pixel_driver:hdmi_pixel_driver|pixfifo_req_o} -to {sld_signaltap:auto_signaltap_0|acq_data_in_reg[20]}
set_false_path -from {sld_signaltap:auto_signaltap_1|sld_signaltap_impl:sld_signaltap_body|sld_signaltap_implb:sld_signaltap_body|trigger_out_ff} -to {sld_signaltap:auto_signaltap_0|trigger_in_reg}

# to synchronizers
set_false_path -from {sdram_reader:sdram_reader|first_fill_flag_o} -to {synchronizer:synchronizer_pixel_announce|sync_regs[0]}
set_false_path -from {adv7513_driver:adv7513_driver|CONFIG_STATUS~DUPLICATE} -to {synchronizer:synchronizer_hdmi_conf_done|sync_regs[0]}
set_false_path -from {synchronizer:synchronizer_fabric_rst|sync_out} -to {synchronizer:synchronizer_video_reset|sync_regs[0]}


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************