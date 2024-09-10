vlib work
onerror { stop}

vlog /home/brandon/work/de10_nano/ip/fifo/frame_fifo.v
vlog /home/brandon/work/de10_nano/hdl/sdram_reader.sv
vlog /home/brandon/work/de10_nano/tb/tb_sdram_controller.sv


set TOP_LEVEL_NAME tb_sdram_controller
vsim -t 1ns -L work -L altera_mf_ver -voptargs="+acc" tb_sdram_controller -do sdram_controller.do

# add wave *
# view structure
# view signals
run -all
wave zoomfull