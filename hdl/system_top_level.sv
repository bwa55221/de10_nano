// `default_nettype none

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

wire rst_n;
assign rst_n = KEY[0];

wire        h2f_waitrequest;
wire [63:0] h2f_readdata;
wire        h2f_readdatavalid;
wire        h2f_burstcount;
wire [63:0] h2f_writedata;
wire [9:0]  h2f_address;
wire        h2f_write;
wire        h2f_read;
wire [7:0]  h2f_byteenable;

	soc_system u0 (

		.hps_0_h2f_reset_reset_n  (), // hps_0_h2f_reset.reset_n (output)
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

        .msgdma_0_st_source_data  (st_data),            // msgdma_0_st_source.data
		.msgdma_0_st_source_valid (valid),              //                   .valid
		.msgdma_0_st_source_ready (ready),              //                   .ready
        .pll_0_165m_clk           (pixel_clk_165M),     //         pll_0_165m.clk
		.pll_0_locked_export      (),                   //       pll_0_locked.export
		.pll_0_reset_reset        (~rst_n)              //        pll_0_reset.reset
	);


wire [F2HSDRAM_DW-1:0] st_data;
wire valid;
wire ready;

    test_st_sink #(
        .DATA_WIDTH (F2HSDRAM_DW)
    ) test_st_sink (
        .clk        (FPGA_CLK1_50),
        .rst        (~rst_n),
        .st_data    (st_data),
        .valid      (valid),
        .ready      (ready)
    );

    blink blink(
        .clk        (FPGA_CLK1_50),
        .led        (LED[0])
    );

    h2f_bridge_slave h2f_bridge_slave(
        .clk            (FPGA_CLK1_50       ),
        .rst            (~rst_n),
        .waitrequest    (h2f_waitrequest    ),
        .readdata       (h2f_readdata       ),
        .readdatavalid  (h2f_readdatavalid  ),
        .burstcount     (h2f_burstcount     ),
        .writedata      (h2f_writedata      ),
        .address        (h2f_address        ),
        .write          (h2f_write          ),
        .read           (h2f_read           ),
        .byteenable     (h2f_byteenable     )
    );


    wire hdmi_conf_done;
    wire pixel_clk_165M;
    assign HDMI_TX_CLK = pixel_clk_165M;

    adv7513_driver adv7513_driver(
        .SYS_CLK        (pixel_clk_165M),     // hdmi tx clock
        .SYS_RST_n      (rst_n),     // system reset
        .ADV_I2C_SCL    (HDMI_I2C_SCL),     
        .ADV_I2C_SDA    (HDMI_I2C_SDA),
        .CONFIG_STATUS  (hdmi_conf_done)      // output to inform hdmi tcvr config done
    );

    rgb_driver rgb_driver (
        .rgb_clk_i          (pixel_clk_165M),     // 165 MHz pixel clock
        .rgb_rst_n_i        (rst_n),
        .transceiver_ready  (hdmi_conf_done),     // connect to config done output from adv7513 driver
        .rgb_pixel_data_o   (HDMI_TX_D),     // 24 bit array
        .rgb_vsync_o        (HDMI_TX_VS),
        .rgb_hsync_o        (HDMI_TX_HS),
        .rgb_data_enable_o  (HDMI_TX_DE)
    );
endmodule