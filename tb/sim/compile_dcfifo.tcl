vlib work
onerror { stop}

vlog /home/brandon/work/de10_nano/ip/fifo/frame_fifo.v
vlog /home/brandon/work/de10_nano/tb/tb_dcfifo.sv


set TOP_LEVEL_NAME tb_dcfifo
vsim -t 1ns -L work -L altera_mf_ver -voptargs="+acc" tb_dcfifo -do dcfifo.do

// add wave *
// view structure
// view signals
run -all
wave zoomfull