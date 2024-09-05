onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_hdmi_pixel_driver/clk
add wave -noupdate /tb_hdmi_pixel_driver/rst
add wave -noupdate /tb_hdmi_pixel_driver/hdmi_tcvr_ready
add wave -noupdate /tb_hdmi_pixel_driver/pixel_ready
add wave -noupdate /tb_hdmi_pixel_driver/pixfifo_req
add wave -noupdate /tb_hdmi_pixel_driver/vsync
add wave -noupdate /tb_hdmi_pixel_driver/hsync
add wave -noupdate /tb_hdmi_pixel_driver/data_enable
add wave -noupdate -radix hexadecimal -childformat {{{/tb_hdmi_pixel_driver/rgb_pixel[23]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[22]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[21]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[20]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[19]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[18]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[17]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[16]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[15]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[14]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[13]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[12]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[11]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[10]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[9]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[8]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[7]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[6]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[5]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[4]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[3]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[2]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[1]} -radix unsigned} {{/tb_hdmi_pixel_driver/rgb_pixel[0]} -radix unsigned}} -subitemconfig {{/tb_hdmi_pixel_driver/rgb_pixel[23]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[22]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[21]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[20]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[19]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[18]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[17]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[16]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[15]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[14]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[13]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[12]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[11]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[10]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[9]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[8]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[7]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[6]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[5]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[4]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[3]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[2]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[1]} {-height 26 -radix unsigned} {/tb_hdmi_pixel_driver/rgb_pixel[0]} {-height 26 -radix unsigned}} /tb_hdmi_pixel_driver/rgb_pixel
add wave -noupdate /tb_hdmi_pixel_driver/hdmi_pixel_driver/read_counter_o
add wave -noupdate /tb_hdmi_pixel_driver/hdmi_pixel_driver/h_act
add wave -noupdate /tb_hdmi_pixel_driver/hdmi_pixel_driver/v_act
add wave -noupdate -expand -group VHDL_MODULE /tb_hdmi_pixel_driver/rgb_pixel
add wave -noupdate -expand -group VHDL_MODULE /tb_hdmi_pixel_driver/rgb_vsync
add wave -noupdate -expand -group VHDL_MODULE /tb_hdmi_pixel_driver/rgb_hsync
add wave -noupdate -expand -group VHDL_MODULE /tb_hdmi_pixel_driver/rgb_data_enable
add wave -noupdate -expand -group VHDL_MODULE /tb_hdmi_pixel_driver/rgb_rgb_pixel
add wave -noupdate /tb_hdmi_pixel_driver/rgb_driver/h_act
add wave -noupdate /tb_hdmi_pixel_driver/rgb_driver/v_act
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {903965 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 500
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
WaveRestoreZoom {903764 ns} {904166 ns}
bookmark add wave bookmark0 {{1013611 ns} {1014419 ns}} 0
