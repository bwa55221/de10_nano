onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_sdram_controller/sdram_clk
add wave -noupdate /tb_sdram_controller/pixel_clk
add wave -noupdate /tb_sdram_controller/rst
add wave -noupdate /tb_sdram_controller/frame_ready
add wave -noupdate /tb_sdram_controller/first_fill_flag
add wave -noupdate /tb_sdram_controller/sdram_waitrequest
add wave -noupdate /tb_sdram_controller/sdram_readdatavalid
add wave -noupdate /tb_sdram_controller/sdram_read
add wave -noupdate /tb_sdram_controller/sdram_readdata
add wave -noupdate /tb_sdram_controller/pixel_out
add wave -noupdate /tb_sdram_controller/pixel_req
add wave -noupdate /tb_sdram_controller/read_in_count
add wave -noupdate /tb_sdram_controller/pixel_out_count
add wave -noupdate /tb_sdram_controller/sdram_reader/fifo_full_flag
add wave -noupdate /tb_sdram_controller/sdram_reader/accepted_read
add wave -noupdate /tb_sdram_controller/sdram_reader/read_allowance
add wave -noupdate /tb_sdram_controller/sdram_reader/breath_clk_count
add wave -noupdate /tb_sdram_controller/sdram_reader/wrusedw
add wave -noupdate /tb_sdram_controller/sdram_reader/frame_fifo/rdusedw
add wave -noupdate /tb_sdram_controller/sdram_reader/frame_fifo/rdempty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {16221 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 488
configure wave -valuecolwidth 100
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
WaveRestoreZoom {16087 ns} {16355 ns}
bookmark add wave bookmark0 {{1013611 ns} {1014419 ns}} 0
