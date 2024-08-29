/*
    This module should read data from the SDRAM.
    The readdata should be pushed into a FIFO that will transfer the data across clock boundaries. 


*/


module sdram_reader(

    input wire          sdram_clk,
    input wire          pixel_clk,
    input wire          rst,

    input wire          frame_ready_i,        // indicate that there is data in sdram, perhaps this is 2 bits


    output logic [26:0] sdram_address_o,
    output logic [7:0]  sdram_burstcount_o,
    input wire          sdram_waitrequest_i,
    input wire [255:0]  sdram_readdata_i,
    input wire          sdram_readdatavalid_i,
    output wire         sdram_read_o,

    input wire          pixel8_req_i,
    output wire [255:0] pixel8_o   
    
);

// logic [26:0] pixel_addr;
logic fifo_full_flag;

assign sdram_burstcount_o = 0;

always_ff @ (posedge sdram_clk) begin
    if (rst) begin
        sdram_address_o <= 0;
        sdram_read_o    <= 0;
    end else begin
        if (frame_ready_i & ~fifo_full_flag) begin
            sdram_read      <= 1;
            sdram_address_o <= sdram_address_o + 1;                       
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