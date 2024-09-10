`timescale 1ns/1ps
// `define FILL_FROM_FILE
/*
    Use this module to:
    - Confirm the latency and location of FIFO status signals (usedw/full/empty, etc...)

*/

module tb_dcfifo();


logic clk, rst;
always #1 clk = ~clk;

int fd;
int fptr, byte_count, return_code;
logic [31:0] tempdata [0:255]; // define 256 double word memory array

logic sdram_readdatavalid_i;
logic fifo_read_req;
logic [255:0] fifo_data_in;

// instantiate fifo
frame_fifo	frame_fifo (
	.data       (fifo_data_in),     
	.rdclk      (clk),
	.rdreq      (fifo_read_req),
	.wrclk      (clk),
	.wrreq      (sdram_readdatavalid_i),
    .aclr       (rst),
	.q          (),           
	.rdempty    (),
	.rdusedw    (),
	.wrfull     (),
    .wrusedw    ()
	);
// instantiate sdram read controller


// read data into memory
initial begin

    // setup initial conditions
    clk <= 1;
    rst <= 1;
    sdram_readdatavalid_i   <= 0;
    fifo_data_in            <= 255'b0;
    fifo_read_req           <= 1'b0;
    repeat (3) @ (posedge clk);
    rst <= 0;
    repeat (3) @ (posedge clk);

    // read in binary data file
    read_binary_file();
    repeat (10) @ (posedge clk);

    // fill fifo
    repeat (1) fill_fifo();
    repeat (10) @ (posedge clk);

    // read from fifo
    read_fifo();
    repeat (10) @ (posedge clk);

    $stop;



end

task read_fifo();
    for (int i = 0; i < 256; i++) begin
        fifo_read_req <= 1;
        @ (posedge clk);

        fifo_read_req <= 0;
        // use urandom%10 to create unsigned random between 0 and 10 -- generates a random delay between reads
        repeat ($urandom%10) @ (posedge clk);
    end

endtask


task fill_fifo();

    `ifdef FILL_FROM_FILE
    
        for(int i = 0; i < 8; i++) begin
            fifo_data_in <= fifo_data_in + (tempdata[i] << i*32);
            $display("fifo_data_in: %64h", fifo_data_in);
            @(posedge clk);
        end
        sdram_readdatavalid_i   <= 1'b1;
        @(posedge clk);
        sdram_readdatavalid_i   <= 1'b0;
        @(posedge clk);

    `else
        for (int i = 0; i < 256; i++) begin
            fifo_data_in <= i;
            sdram_readdatavalid_i   <= 1'b1;
            @(posedge clk);
            sdram_readdatavalid_i   <= 1'b0;
            @(posedge clk);
        end
    `endif
    
endtask


task read_binary_file();
    fptr = 0;
    byte_count = 255;

    fd = $fopen("/home/brandon/work/de10_nano/user_software/image_conversion/raw_image.raw", "rb"); // specify read bytes with "rb"
    if (fd == 0) begin
        $display("Error: Could not open file.");
        $stop;
    end  

    return_code = $fread(tempdata, fd, fptr, fptr+byte_count);
    if (return_code == 0) begin
        $display("Error: Could not read data.");
    end else begin
        $display("Read %0d bytes of data.", return_code);
    end

    for (int i = 0; i < 8; i++) begin
        $strobe("tempdata[%0d] = %h", i, tempdata[i]);
        @ (posedge clk);
    end
endtask


endmodule