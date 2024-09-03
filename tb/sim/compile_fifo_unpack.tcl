vlib work
onerror { stop}

vlog /home/brandon/work/de10_nano/tb/tb_fifo_unpack.sv


set TOP_LEVEL_NAME tb_fifo_unpack

vsim -t 1ns -L work -voptargs="+acc" tb_fifo_unpack

add wave *
view structure
view signals
run -all
wave zoomfull