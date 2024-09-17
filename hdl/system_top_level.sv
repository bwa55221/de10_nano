`default_nettype none

// `define mSGDMA_ENABLE
// `define TEST_PATTERN

module system_top_level (

        //////////// CLOCK //////////
    input               FPGA_CLK1_50,
    input               FPGA_CLK2_50,
    input               FPGA_CLK3_50,

    //////////// HDMI //////////
    inout               HDMI_I2C_SCL,
    inout               HDMI_I2C_SDA,
    inout               HDMI_I2S,
    inout               HDMI_LRCLK,
    inout               HDMI_MCLK,
    inout               HDMI_SCLK,
    output              HDMI_TX_CLK,
    output   [23: 0]    HDMI_TX_D,
    output              HDMI_TX_DE,
    output              HDMI_TX_HS,
    input               HDMI_TX_INT,
    output              HDMI_TX_VS,

    //////////// HPS //////////
    inout               HPS_CONV_USB_N,
    output   [14: 0]    HPS_DDR3_ADDR,
    output   [ 2: 0]    HPS_DDR3_BA,
    output              HPS_DDR3_CAS_N,
    output              HPS_DDR3_CK_N,
    output              HPS_DDR3_CK_P,
    output              HPS_DDR3_CKE,
    output              HPS_DDR3_CS_N,
    output   [ 3: 0]    HPS_DDR3_DM,
    inout    [31: 0]    HPS_DDR3_DQ,
    inout    [ 3: 0]    HPS_DDR3_DQS_N,
    inout    [ 3: 0]    HPS_DDR3_DQS_P,
    output              HPS_DDR3_ODT,
    output              HPS_DDR3_RAS_N,
    output              HPS_DDR3_RESET_N,
    input               HPS_DDR3_RZQ,
    output              HPS_DDR3_WE_N,
    output              HPS_ENET_GTX_CLK,
    inout               HPS_ENET_INT_N,
    output              HPS_ENET_MDC,
    inout               HPS_ENET_MDIO,
    input               HPS_ENET_RX_CLK,
    input    [ 3: 0]    HPS_ENET_RX_DATA,
    input               HPS_ENET_RX_DV,
    output   [ 3: 0]    HPS_ENET_TX_DATA,
    output              HPS_ENET_TX_EN,
    inout               HPS_GSENSOR_INT,
    inout               HPS_I2C0_SCLK,
    inout               HPS_I2C0_SDAT,
    inout               HPS_I2C1_SCLK,
    inout               HPS_I2C1_SDAT,
    inout               HPS_KEY,
    inout               HPS_LED,
    inout               HPS_LTC_GPIO,
    output              HPS_SD_CLK,
    inout               HPS_SD_CMD,
    inout    [ 3: 0]    HPS_SD_DATA,
    output              HPS_SPIM_CLK,
    input               HPS_SPIM_MISO,
    output              HPS_SPIM_MOSI,
    inout               HPS_SPIM_SS,
    input               HPS_UART_RX,
    output              HPS_UART_TX,
    input               HPS_USB_CLKOUT,
    inout    [ 7: 0]    HPS_USB_DATA,
    input               HPS_USB_DIR,
    input               HPS_USB_NXT,
    output              HPS_USB_STP,

    //////////// KEY //////////
    input    [ 1: 0]    KEY,

    //////////// LED //////////
    output   [ 7: 0]    LED,

    //////////// SW //////////
    input    [ 3: 0]    SW
);


localparam F2HSDRAM_DW = 256;
localparam F2HSDRAM_ADDRW = 27;


wire pulse_rst_n;
wire fabric_rst_n;
wire rst;
assign fabric_rst_n = KEY[0] && pulse_rst_n;

wire [F2HSDRAM_DW-1:0] st_data;
wire valid;
wire ready;

wire        h2f_waitrequest;
wire [63:0] h2f_readdata;
wire        h2f_readdatavalid;
wire        h2f_burstcount;
wire [63:0] h2f_writedata;
wire [9:0]  h2f_address;
wire        h2f_write;
wire        h2f_read;
wire [7:0]  h2f_byteenable;

wire        lwh2f_waitrequest;
wire [31:0] lwh2f_readdata;
wire        lwh2f_readdatavalid;
wire        lwh2f_burstcount;
wire [31:0] lwh2f_writedata;
wire [9:0]  lwh2f_address;
wire        lwh2f_write;
wire        lwh2f_read;
wire [3:0]  lwh2f_byteenable;


wire [F2HSDRAM_ADDRW-1:0]       f2h_sdram_address;
wire [7:0]                      f2h_sdram_burstcount;
wire                            f2h_sdram_waitrequest;
wire [F2HSDRAM_DW-1:0]          f2h_sdram_readdata;
wire                            f2h_sdram_readdatavalid;
wire                            f2h_sdram_read;

	soc_system u0 (

		.hps_bridge_waitrequest   (h2f_waitrequest), // hps_bridge.waitrequest
		.hps_bridge_readdata      (h2f_readdata), // .readdata
		.hps_bridge_readdatavalid (h2f_readdatavalid), // .readdatavalid
		.hps_bridge_burstcount    (h2f_burstcount), // .bustcount
		.hps_bridge_writedata     (h2f_writedata), // .writedata
		.hps_bridge_address       (h2f_address), // .address
		.hps_bridge_write         (h2f_write), // .write
		.hps_bridge_read          (h2f_read), // .read
		.hps_bridge_byteenable    (h2f_byteenable), // .byteenable
		.hps_bridge_debugaccess   (), // .debugaccess

		.memory_mem_a             (HPS_DDR3_ADDR), // memory.mem_a
		.memory_mem_ba            (HPS_DDR3_BA), // .mem_ba
		.memory_mem_ck            (HPS_DDR3_CK_P), // .mem_ck
		.memory_mem_ck_n          (HPS_DDR3_CK_N), // .mem_ck_n
		.memory_mem_cke           (HPS_DDR3_CKE), // .mem_cke
		.memory_mem_cs_n          (HPS_DDR3_CS_N), // .mem_cs_n
		.memory_mem_ras_n         (HPS_DDR3_RAS_N), // .mem_ras_n
		.memory_mem_cas_n         (HPS_DDR3_CAS_N), // .mem_cas_n
		.memory_mem_we_n          (HPS_DDR3_WE_N), // .mem_we_n
		.memory_mem_reset_n       (HPS_DDR3_RESET_N), // .mem_reset_n
		.memory_mem_dq            (HPS_DDR3_DQ), // .mem_dq
		.memory_mem_dqs           (HPS_DDR3_DQS_P), // .mem_dqs
		.memory_mem_dqs_n         (HPS_DDR3_DQS_N), // .mem_dqs_n
		.memory_mem_odt           (HPS_DDR3_ODT), // .mem_odt
		.memory_mem_dm            (HPS_DDR3_DM), // .mem_dm
		.memory_oct_rzqin         (HPS_DDR3_RZQ), // .oct_rzqin

        .clk_clk                  (FPGA_CLK1_50), // clk.clk
        .hps_0_h2f_reset_reset_n  (), //output from h2f reset manager

        `ifdef mSGDMA_ENABLE
        .msgdma_0_st_source_data  (st_data),            // msgdma_0_st_source.data
		.msgdma_0_st_source_valid (valid),              //                   .valid
		.msgdma_0_st_source_ready (ready),              //                   .ready
        `endif

        .pll_0_165m_clk           (pixel_clk_165M           ), //         pll_0_165m.clk
		.pll_0_locked_export      (                         ), //       pll_0_locked.export

        .f2h_sdram_address        (f2h_sdram_address        ), //    f2h_sdram.address width=27
		.f2h_sdram_burstcount     (f2h_sdram_burstcount     ), //             .burstcount width=8
		.f2h_sdram_waitrequest    (f2h_sdram_waitrequest    ), //             .waitrequest
		.f2h_sdram_readdata       (f2h_sdram_readdata       ), //             .readdata width=256
		.f2h_sdram_readdatavalid  (f2h_sdram_readdatavalid  ), //             .readdatavalid
		.f2h_sdram_read           (f2h_sdram_read           ), //             .read
        .f2h_sdram_writedata      (64'b0), //                        .writedata
		.f2h_sdram_byteenable     (32'b0), //                        .byteenable
		.f2h_sdram_write          (1'b0), //                        .write

        .fabric_reset_in_reset    (~fabric_rst_n_syncd), // fabric_reset_in.reset

        .lwh2f_bridge_waitrequest   (lwh2f_waitrequest  ), //    lwh2f_bridge.waitrequest
		.lwh2f_bridge_readdata      (lwh2f_readdata     ), //                .readdata
		.lwh2f_bridge_readdatavalid (lwh2f_readdatavalid), //                .readdatavalid
		.lwh2f_bridge_burstcount    (lwh2f_burstcount   ), //                .burstcount
		.lwh2f_bridge_writedata     (lwh2f_writedata    ), //                .writedata
		.lwh2f_bridge_address       (lwh2f_address      ), //                .address
		.lwh2f_bridge_write         (lwh2f_write        ), //                .write
		.lwh2f_bridge_read          (lwh2f_read         ), //                .read
		.lwh2f_bridge_byteenable    (lwh2f_byteenable   ), //                .byteenable
		.lwh2f_bridge_debugaccess   (                   ), //                .debugaccess

		.glob_reset_reset         (rst)  //      glob_reset.reset
	);



// ********************************************
// ********************************************
//             Fabric Clock Domain
// ********************************************
// ********************************************

    // generate POR pulse once fabric clock is running
    por_pulse por_pulse (
        .CLOCK      (FPGA_CLK1_50),
        .RESET_N    (pulse_rst_n)
    );

    // test_st_sink #(
    //     .DATA_WIDTH (F2HSDRAM_DW)
    // ) test_st_sink (
    //     .clk        (FPGA_CLK1_50),
    //     .rst        (rst),
    //     .st_data    (st_data),
    //     .valid      (valid),
    //     .ready      (ready)
    // );

    // fpga logic programmed ? -- status blinker
    blink blink(
        .clk        (FPGA_CLK1_50),
        .rst        (rst),
        .led        (LED[0])
    );

    // resample fabric reset before feeding into QSYS block
    // this is needed because the button reset is ASYNC
    wire fabric_rst_n_syncd;
    synchronizer synchronizer_fabric_rst (
    .async_in           (fabric_rst_n),
    .clk                (FPGA_CLK1_50),
    .sync_out           (fabric_rst_n_syncd),
    .rise_edge_tick     (),
    .fall_edge_tick     ()
    );


    wire [63:0] reg64data;
    h2f_bridge_slave #(
        .H2F_DATAWIDTH (64)
    ) h2f_bridge_slave(
        .clk                (FPGA_CLK1_50       ),
        .rst                (rst                ),
        .waitrequest        (h2f_waitrequest    ),
        .readdata           (h2f_readdata       ),
        .readdatavalid      (h2f_readdatavalid  ),
        .burstcount         (h2f_burstcount     ),
        .writedata          (h2f_writedata      ),
        .address            (h2f_address        ),
        .write              (h2f_write          ),
        .read               (h2f_read           ),
        .byteenable         (h2f_byteenable     ),
        .fabric_regsel_i    (0),
        .fabric_regwrite_i  (),
        .fabric_regdata_i   (),
        .fabric_regdata_o   (reg64data)
    );

    wire [31:0] reg32data;
    h2f_bridge_slave #(
        .H2F_DATAWIDTH (32)
    ) lwh2f_bridge_slave(
        .clk                (FPGA_CLK1_50       ),
        .rst                (rst                ),
        .waitrequest        (lwh2f_waitrequest  ),
        .readdata           (lwh2f_readdata     ),
        .readdatavalid      (lwh2f_readdatavalid),
        .burstcount         (lwh2f_burstcount   ),
        .writedata          (lwh2f_writedata    ),
        .address            (lwh2f_address      ),
        .write              (lwh2f_write        ),
        .read               (lwh2f_read         ),
        .byteenable         (lwh2f_byteenable   ),
        .fabric_regsel_i    (2),
        .fabric_regwrite_i  (),
        .fabric_regdata_i   (),
        .fabric_regdata_o   (reg32data)
    );

    wire pixel_announce;
    wire pixel_announce_syncd;
    wire pixel_word_request;
    wire [F2HSDRAM_DW-1:0] pixel_word;
    sdram_reader #(
        .SDRAM_DATA_WIDTH (F2HSDRAM_DW)
        ) sdram_reader
        (
        .sdram_clk              (FPGA_CLK1_50           ),
        .pixel_clk              (pixel_clk_165M         ),
        .rst                    (rst                    ),
        .frame_ready_i          (reg32data[16]          ), // bit 0 of register 0 is used to trigger start of read
        .first_fill_flag_o      (pixel_announce         ),
        .sdram_address_o        (f2h_sdram_address      ),
        .sdram_burstcount_o     (f2h_sdram_burstcount   ),
        .sdram_waitrequest_i    (f2h_sdram_waitrequest  ),
        .sdram_readdata_i       (f2h_sdram_readdata     ),
        .sdram_readdatavalid_i  (f2h_sdram_readdatavalid),
        .sdram_read_o           (f2h_sdram_read         ),
        .pixel8_req_i           (pixel_word_request     ),
        .pixel8_o               (pixel_word             )
    );


    wire hdmi_conf_done;
    wire hdmi_conf_done_syncd;
    wire pixel_clk_165M;
    wire video_rst;
    assign HDMI_TX_CLK = pixel_clk_165M;

    // add module to delay configuration of the ADV7513 until 200 ms after device POR reset occurs
    wire adv7513_delayed_reset;
    delayed_reset delayed_reset (
        .clk_i          (FPGA_CLK1_50),
        .rst_i          (rst),
        .delayed_rst_o  (adv7513_delayed_reset)
    );

    adv7513_driver adv7513_driver(
        .SYS_CLK        (FPGA_CLK1_50           ),     // hdmi tx clock
        .SYS_RST_n      (~adv7513_delayed_reset ),     // system reset
        .ADV_I2C_SCL    (HDMI_I2C_SCL           ),     
        .ADV_I2C_SDA    (HDMI_I2C_SDA           ),
        .CONFIG_STATUS  (hdmi_conf_done         )      // output to inform hdmi tcvr config done
    );




// ********************************************
// ********************************************
//             Pixel Clock Domain
// ********************************************
// ********************************************

    // synchronize fabric reset to pixel clock domain
    synchronizer synchronizer_video_reset(
    .async_in           (rst),
    .clk                (pixel_clk_165M),
    .sync_out           (video_rst),
    .rise_edge_tick     (),
    .fall_edge_tick     ()
    );

    // synchronize HDMI IC Configuration Done to Pixel Clock Domain
    synchronizer synchronizer_hdmi_conf_done(
    .async_in           (hdmi_conf_done),
    .clk                (pixel_clk_165M),
    .sync_out           (hdmi_conf_done_syncd),
    .rise_edge_tick     (),
    .fall_edge_tick     ()
    );

    // synchronize pixel ready annoucnement to pixel clock domain (from sdram reader)
    synchronizer synchronizer_pixel_announce(
    .async_in           (pixel_announce),
    .clk                (pixel_clk_165M),
    .sync_out           (pixel_announce_syncd),
    .rise_edge_tick     (),
    .fall_edge_tick     ()
    );


    `ifdef TEST_PATTERN
    rgb_driver rgb_driver (
        .rgb_clk_i          (pixel_clk_165M ),     // 165 MHz pixel clock
        .rgb_rst_n_i        (~video_rst     ),
        .transceiver_ready  (hdmi_conf_done_syncd),     // connect to config done output from adv7513 driver
        .rgb_pixel_data_o   (HDMI_TX_D      ),     // 24 bit array
        .rgb_vsync_o        (HDMI_TX_VS     ),
        .rgb_hsync_o        (HDMI_TX_HS     ),
        .rgb_data_enable_o  (HDMI_TX_DE     )
    );
    `else
    hdmi_pixel_driver #(
        .PIXEL_FIFO_DATA_WIDTH (F2HSDRAM_DW)
        ) hdmi_pixel_driver (
        .clk_i              (pixel_clk_165M         ),
        .rst_i              (video_rst              ),
        .hdmi_tcvr_ready_i  (hdmi_conf_done_syncd   ),
        .pixel_ready_i      (pixel_announce_syncd   ),
        .pixfifo_word_i     (pixel_word             ),
        .pixfifo_req_o      (pixel_word_request     ),
        .rgb_pixel_o        (HDMI_TX_D              ),
        .vsync_o            (HDMI_TX_VS             ),
        .hsync_o            (HDMI_TX_HS             ),
        .data_enable_o      (HDMI_TX_DE             ),
        .read_counter_o     (                       )
    );
    `endif
endmodule

`ifdef QUARTUS_ENV
    `default_nettype wire
`endif