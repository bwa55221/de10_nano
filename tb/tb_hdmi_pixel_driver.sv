`default_nettype none
`timescale 1ns/1ps

module tb_hdmi_pixel_driver();

logic clk, rst;
logic hdmi_tcvr_ready;
logic pixel_ready;

// logic required for wire interfaces of dut module (hdmi driver)
logic pixfifo_req, vsync, hsync, data_enable;
logic [23:0] rgb_pixel;

// logic for vhdl rgb driver
logic rgb_vsync, rgb_hsync, rgb_data_enable;
logic [23:0] rgb_rgb_pixel;


always #5 clk = ~clk;


hdmi_pixel_driver hdmi_pixel_driver(
    .clk_i                  (clk            ),
    .rst_i                  (rst            ),
    .hdmi_tcvr_ready_i      (hdmi_tcvr_ready),
    .pixel_ready_i          (pixel_ready    ),
    .pixfifo_word_i         (0              ),
    .pixfifo_req_o          (pixfifo_req    ),  // wires require a logic connection to dut
    .rgb_pixel_o            (rgb_pixel      ),
    .vsync_o                (vsync          ),  // wires require a logic connection to dut
    .hsync_o                (hsync          ),  // wires require a logic connection to dut
    .data_enable_o          (data_enable    )   // wires require a logic connection to dut
);

// alternate hdmi driver (VHDL)
rgb_driver rgb_driver(
    .rgb_clk_i          (clk),
    .rgb_rst_n_i        (~rst),
    .transceiver_ready  (hdmi_tcvr_ready),
    .rgb_pixel_data_o   (rgb_rgb_pixel),
    .rgb_vsync_o        (rgb_vsync),
    .rgb_hsync_o        (rgb_hsync),
    .rgb_data_enable_o  (rgb_data_enable)
);


initial begin
    clk             <= 0;
    rst             <= 1;
    hdmi_tcvr_ready <= 0;
    pixel_ready     <= 0;

    repeat (5) @ (posedge clk);
    rst             <= 0;
    hdmi_tcvr_ready <= 1;
    pixel_ready     <= 1;
    repeat (2500000) @ (posedge clk);

    $stop;

end


endmodule