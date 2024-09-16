/*
    This module uses AVMM transactions to pull data out of SDRAM allocated to the F2HSDRAM bridge (DDR3).
    The retrieved data is stored into an asynchronous FIFO. Once the FIFO is filled for the first time,
    (in this example, with pixel data), the module sends an alert, "first_fill_flag_o" to alert exterior modules
    that data is present and ready for extraction from the FIFO. 
*/
`default_nettype none

module sdram_reader #(
    parameter SDRAM_DATA_WIDTH = 64
    )(

    input  wire                         sdram_clk,
    input  wire                         pixel_clk,
    input  wire                         rst,

    input  wire                         frame_ready_i,        // indicate that there is data in sdram, perhaps this is 2 bits
    output logic                        first_fill_flag_o,


    output logic [26:0              ]   sdram_address_o,
    output logic [7:0               ]   sdram_burstcount_o,
    input  wire                         sdram_waitrequest_i,
    input  wire [SDRAM_DATA_WIDTH-1:0]  sdram_readdata_i,
    input  wire                         sdram_readdatavalid_i,
    output logic                        sdram_read_o,

    input  wire                         pixel8_req_i,
    output logic [SDRAM_DATA_WIDTH-1:0] pixel8_o   
    );

localparam FIFO_DEPTH = 256;
localparam FIFO_HEADROOM = 25;       // allowable amount of empty words in pixel FIFO before requesting more data from SDRAM
localparam BREATH_COUNT = 60;       // clock cycles to wait for requested reads to return
localparam READ_ALLOWANCE_TRIGER = 1;

localparam FRAME_BITS_1080P = 32'h3F48000;
localparam BUFFER0_BYTE_ADDR = 32'h2000_0000;
localparam BUFFER0_AVALON_ADDR = BUFFER0_BYTE_ADDR/(SDRAM_DATA_WIDTH/8); // 0x400_0000 (64 bit width)
localparam COMPLETE_FRAME_COUNT = (FRAME_BITS_1080P/SDRAM_DATA_WIDTH); // 0xFD1FF (64 bit width)

// control signals
logic [$clog2(FIFO_DEPTH):0] read_allowance;
logic accepted_read;
logic [$clog2(BREATH_COUNT):0] breath_clk_count;
assign accepted_read = sdram_read_o & ~sdram_waitrequest_i;
logic [$clog2(FIFO_DEPTH):0] wrusedw;

// read addressing registers
logic [26:0] read_address;

// set a default burst count
assign sdram_burstcount_o = 8'b1; // just use single burst accesses for now.

// some logic to let pixel driver know fifo is filled
logic fifo_full_flag;
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

/*
    OTHER NOTE:
    Need to account for reads that are submitted but not yet returned -- use, something other 
    than the FIFO FULL FLAG to determine when to stop reading. 
*/



always_ff @ (posedge sdram_clk) begin
    if (rst) begin
        sdram_address_o <= BUFFER0_AVALON_ADDR;
        read_address    <= BUFFER0_AVALON_ADDR;
        sdram_read_o    <= 0;
    end else begin

        // priority check for waitrequest
        if (sdram_waitrequest_i) begin
                sdram_read_o        <= sdram_read_o;
                sdram_address_o     <= sdram_address_o;
                read_address        <= read_address;

        end else begin

            if (frame_ready_i & ~fifo_full_flag & (read_allowance >= 1)) begin 
                sdram_read_o        <= 1;
                sdram_address_o     <= read_address;
                read_address        <= read_address + 1;

                // if read_address is emitted out during last value, recycle, otherwise hold static
                if (read_address == (BUFFER0_AVALON_ADDR + COMPLETE_FRAME_COUNT - 1)) begin
                    read_address    <= BUFFER0_AVALON_ADDR;
                end

            end else begin
                sdram_read_o        <= 0;
                sdram_address_o     <= sdram_address_o;
                read_address        <= read_address;
            end
        
        end
    end
end

// manage the read allowance and DDR breathing
always_ff @ (posedge sdram_clk) begin
    if (rst) begin
        read_allowance      <= 255;
        breath_clk_count    <= BREATH_COUNT;

    end else begin
        
        if (accepted_read & (read_allowance >= 1)) begin // add a check to prevent read allowance from rolling over
            read_allowance <= read_allowance - 1;
        end else begin
            read_allowance <= read_allowance;
        end

        if (read_allowance == 0) begin
            if (breath_clk_count == 0) begin
                if (wrusedw < (FIFO_DEPTH - 1 - FIFO_HEADROOM)) begin
                    read_allowance      <= FIFO_DEPTH - wrusedw - 2; // wrusedw is 1 clk delayed, read_allowance is 0 indexed, FIFO_DEPTH is 1 indexed (hence the -1)
                    breath_clk_count    <= BREATH_COUNT;
                end
            end else begin
                breath_clk_count <= breath_clk_count -1;
            end
        end

    end
end

// regenerated fifo in standard (non-lookahead mode)
new_fifo	new_fifo_inst (
	.aclr       (rst                    ),
	.data       (sdram_readdata_i       ),
	.rdclk      (pixel_clk              ),
	.rdreq      (pixel8_req_i           ),
	.wrclk      (sdram_clk              ),
	.wrreq      (sdram_readdatavalid_i  ),
	.q          (pixel8_o               ),
	.rdempty    (),
	.rdusedw    (),
	.wrfull     (fifo_full_flag         ),
	.wrusedw    (wrusedw                )
	);
endmodule

`ifdef QUARTUS_ENV
    `default_nettype wire
`endif