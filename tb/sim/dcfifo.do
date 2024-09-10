onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_sdram_reader/clk
add wave -noupdate /tb_sdram_reader/fd
add wave -noupdate /tb_sdram_reader/fptr
add wave -noupdate /tb_sdram_reader/byte_count
add wave -noupdate /tb_sdram_reader/return_code
add wave -noupdate /tb_sdram_reader/tempdata
add wave -noupdate /tb_sdram_reader/fifo_data_in
add wave -noupdate /tb_sdram_reader/frame_fifo/q
add wave -noupdate /tb_sdram_reader/frame_fifo/wrusedw
add wave -noupdate /tb_sdram_reader/sdram_readdatavalid_i
add wave -noupdate /tb_sdram_reader/frame_fifo/wrfull
add wave -noupdate /tb_sdram_reader/fifo_read_req
add wave -noupdate /tb_sdram_reader/frame_fifo/dcfifo_component/rdusedw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3834 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 316
configure wave -valuecolwidth 240
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {8192 ns}
bookmark add wave bookmark0 {{1013611 ns} {1014419 ns}} 0
