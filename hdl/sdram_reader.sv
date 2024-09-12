/*
    This module should read data from the SDRAM.
    The readdata should be pushed into a FIFO that will transfer the data across clock boundaries. 

    Possible errors:
    1. read_address being overwritten when cycling to new frame address, therefore one address never
    gets read out (would only occur near first frame boundary)
    2. something wrong with fifo IP, I modified it to show-ahead mode without resynthesizing the QIP block. Attempting to fix this 
    now with the "new_fifo" IP, which added an extra MSB for wrusedw, and converted back to standard request mode.
    3. Check to make sure all addresses are correct. Issue now appears to occur within the 2nd horizontal row, should be able to check
    this manually.

*/


module sdram_reader #(
    parameter SDRAM_DATA_WIDTH = 64
    )(

    input wire          sdram_clk,
    input wire          pixel_clk,
    input wire          rst,

    input wire          frame_ready_i,        // indicate that there is data in sdram, perhaps this is 2 bits
    output logic        first_fill_flag_o,


    output logic [26:0              ]   sdram_address_o,
    output logic [7:0               ]   sdram_burstcount_o,
    input wire                          sdram_waitrequest_i,
    input wire [SDRAM_DATA_WIDTH-1:0]   sdram_readdata_i,
    input wire                          sdram_readdatavalid_i,
    output logic                         sdram_read_o,

    input wire                          pixel8_req_i,
    output logic [SDRAM_DATA_WIDTH-1:0]  pixel8_o   
    );

localparam FIFO_DEPTH = 256;
localparam FIFO_HEADROOM = 25;       // allowable amount of empty words in pixel FIFO before requesting more data from SDRAM
localparam BREATH_COUNT = 60;       // clock cycles to wait for requested reads to return
localparam READ_ALLOWANCE_TRIGER = 1;

localparam FRAME_BITS_1080P = 32'h3F48000;
localparam BUFFER0_BYTE_ADDR = 32'h2000_0000;
localparam BUFFER0_AVALON_ADDR = BUFFER0_BYTE_ADDR/(SDRAM_DATA_WIDTH/8); // 0x400_0000 (64 bit width)
localparam COMPLETE_FRAME_COUNT = (FRAME_BITS_1080P/SDRAM_DATA_WIDTH)-1; // 0xFD1FF (64 bit width)

// control signals
logic [$clog2(FIFO_DEPTH):0] read_allowance;
logic accepted_read;
logic [$clog2(BREATH_COUNT):0] breath_clk_count;
assign accepted_read = sdram_read_o & ~sdram_waitrequest_i;
logic [$clog2(FIFO_DEPTH):0] wrusedw;

// read addressing registers
logic [26:0] read_address;
logic [26:0] read_address_q;

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
    Make sure we read the 0th address, otherwise all pixels are off and shifted from their ideal positions
    This is done by registering the read_address counter and making the base address value arrive the first
    time sdram_read_o signal is asserted. 

    1. read_address starts out 1 address above the base address (to account for 1 clk delay)
    2. sdram_address_o is fed by the registered read address, "read_address_q"
    3. read_address_q is updated with read_address
    4. read_address is incremented by 1
    5. repeat until sdram_output address has performed a read at the last pixel address


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
            if (frame_ready_i & ~fifo_full_flag & (read_allowance >= 1)) begin // changed to >= 1 from > 0 (9/11)
                    sdram_read_o        <= 1;
                    sdram_address_o     <= read_address;
                    read_address        <= read_address + 1;
            end else begin
                sdram_read_o        <= 0;
                sdram_address_o     <= sdram_address_o;
                read_address        <= read_address;
            end

            // cycle back to beginning of frame buffer once we have sent the last read address on the wire
            if (read_address == (BUFFER0_AVALON_ADDR + COMPLETE_FRAME_COUNT)) begin
                read_address    <= BUFFER0_AVALON_ADDR;
            end
        end

        // // if (frame_ready_i & ~fifo_full_flag & (read_allowance > 1)) begin // change this to 1 from 0 
        // if (frame_ready_i & ~fifo_full_flag & (read_allowance > 0)) begin // change this to 1 from 0 
        //     if (~sdram_waitrequest_i) begin
        //         sdram_read_o        <= 1;
        //         sdram_address_o     <= read_address;
        //         read_address        <= read_address + 1;
        //     end else begin
        //         sdram_read_o        <= sdram_read_o;
        //         sdram_address_o     <= sdram_address_o;
        //         read_address        <= read_address;
        //     end
        // end else begin
        //     sdram_read_o        <= 0;
        //     sdram_address_o     <= sdram_address_o;
        //     read_address        <= read_address;
        // end

        // // cycle back to beginning of frame buffer once we have sent the last read address on the wire
        // if (read_address == (BUFFER0_AVALON_ADDR + COMPLETE_FRAME_COUNT)) begin
        //     read_address    <= BUFFER0_AVALON_ADDR;
        // end
    end
end





// always_ff @ (posedge sdram_clk) begin
//     if (rst) begin
//         // sdram_address_o <= BUFFER0_AVALON_ADDR;
//         read_address    <= BUFFER0_AVALON_ADDR + 1;
//         read_address_q  <= BUFFER0_AVALON_ADDR;
//         sdram_address_o <= 0;
//         sdram_read_o    <= 0;

//     end else begin


//         if (frame_ready_i & ~fifo_full_flag & (read_allowance > 1)) begin
//             if (~sdram_waitrequest_i) begin

//                 sdram_read_o    <= 1;                      
//                 sdram_address_o <= read_address_q;

//                 // push next read address into register for next read transaction (should 
//                 // only be updated if entering this loop)
//                 read_address_q  <= read_address;

//                 // increment read_address
//                 read_address++;

//             end else begin
//                 sdram_read_o    <= sdram_read_o;
//                 sdram_address_o <= sdram_address_o;
//                 read_address    <= read_address;
//             end

//         end else begin
//             sdram_read_o        <= 0;
//         end

//         if (read_address_q == (BUFFER0_AVALON_ADDR + COMPLETE_FRAME_COUNT)) begin
//             // sdram_address_o     <= BUFFER0_AVALON_ADDR;
//             read_address        <= BUFFER0_AVALON_ADDR + 1;
//             read_address_q      <= BUFFER0_AVALON_ADDR;
//         end

//     end
// end

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

        // if (read_allowance <= 1) begin
        if (read_allowance == 0) begin
            if (breath_clk_count == 0) begin
                if (wrusedw < (FIFO_DEPTH - 1 - FIFO_HEADROOM)) begin
                    read_allowance      <= (FIFO_DEPTH - 1 - wrusedw) - 1; // wrusedw can be running behind, reduce the read allowance to make sure we don't submit too many fill requests
                    breath_clk_count    <= BREATH_COUNT;
                end
            end else begin
                breath_clk_count <= breath_clk_count -1;
            end
        end

    end
end

// frame_fifo	frame_fifo (
// 	.data       (sdram_readdata_i),     
// 	.rdclk      (pixel_clk),
// 	.rdreq      (pixel8_req_i),
// 	.wrclk      (sdram_clk),
// 	.wrreq      (sdram_readdatavalid_i),
//     .aclr       (rst),
// 	.q          (pixel8_o),           
// 	.rdempty    (),
// 	.rdusedw    (),
// 	.wrfull     (fifo_full_flag),
//     .wrusedw    (wrusedw)
// 	);

new_fifo	new_fifo_inst (
	.aclr       (internal_rst           ),
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