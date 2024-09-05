vlib work
onerror { stop}

vcom -2008 /home/brandon/work/hdmi_tx/hdl/rgb_driver.vhd
vlog /home/brandon/work/de10_nano/hdl/hdmi_pixel_driver.sv
vlog /home/brandon/work/de10_nano/tb/tb_hdmi_pixel_driver.sv


set TOP_LEVEL_NAME tb_hdmi_pixel_driver

vsim -t 1ns -L work -voptargs="+acc" tb_hdmi_pixel_driver -do hdmi_pixel_driver.do

# add wave *
# view structure
# view signals
run -all
wave zoomfull