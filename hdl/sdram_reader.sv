/*
    This module should read data from the SDRAM.
    The readdata should be pushed into a FIFO that will transfer the data across clock boundaries. 


*/


module sdram_reader #(
    parameter SDRAM_DATA_WIDTH = 64
    )(

    input wire          sdram_clk,
    input wire          pixel_clk,
    input wire          rst,

    input wire          frame_ready_i,        // indicate that there is data in sdram, perhaps this is 2 bits
    output logic        first_fill_flag_o,


    output logic [28:0              ]   sdram_address_o,
    output logic [7:0               ]   sdram_burstcount_o,
    input wire                          sdram_waitrequest_i,
    input wire [SDRAM_DATA_WIDTH-1:0]   sdram_readdata_i,
    input wire                          sdram_readdatavalid_i,
    output wire                         sdram_read_o,

    input wire                          pixel8_req_i,
    output wire [SDRAM_DATA_WIDTH-1:0]  pixel8_o   
    );

localparam FRAME_BITS_1080P = 32'h3F48000;
localparam BUFFER0_BYTE_ADDR = 32'h2000_0000;
localparam BUFFER0_AVALON_ADDR = BUFFER0_BYTE_ADDR/SDRAM_DATA_WIDTH;
localparam COMPLETE_FRAME_COUNT = (FRAME_BITS_1080P/SDRAM_DATA_WIDTH)-1;


// some logic to let pixel driver know fifo is filled
always_ff @(posedge sdram_clk) begin
    if (rst) begin
        first_fill_flag_o <= 0;
    end else begin
        if (fifo_full_flag) begin
            first_fill_flag_o <= 1;
        end else begin
            first_fill_flag_o <= first_fill_flag_o;
        end
    end
end



// sdram read controller
logic fifo_full_flag;
assign sdram_burstcount_o = 8'b1; // just use single burst accesses for now.

always_ff @ (posedge sdram_clk) begin
    if (rst) begin
        sdram_address_o <= BUFFER0_AVALON_ADDR;
        sdram_read_o    <= 0;

    end else begin

        if (frame_ready_i & ~fifo_full_flag) begin
            if (~sdram_waitrequest_i) begin
                sdram_read_o    <= 1;                      
                sdram_address_o <= sdram_address_o + 1;
            end else begin
                sdram_read_o    <= sdram_read_o;
                sdram_address_o <= sdram_address_o;
            end
        end else begin
            sdram_read_o        <= 0;
        end

        if (sdram_address_o == COMPLETE_FRAME_COUNT) begin
            sdram_address_o     <= BUFFER0_AVALON_ADDR;
        end

    end
end


// add a fifo that stores data and crosses the clock boundary into pixel clock domain
// 256 bits wide, 256 words deep
frame_fifo	frame_fifo (
	.data       (sdram_readdata_i),     
	.rdclk      (pixel_clk),
	.rdreq      (pixel8_req_i),
	.wrclk      (sdram_clk),
	.wrreq      (sdram_readdatavalid_i),
	.q          (pixel8_o),           
	.rdempty    (),
	.rdusedw    (),
	.wrfull     (fifo_full_flag)
	);

// keep track of the address to pull data out of SDRAM from. 

endmodule