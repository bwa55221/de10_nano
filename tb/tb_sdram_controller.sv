`timescale 1ns/1ps

module tb_sdram_controller();

logic sdram_clk, pixel_clk, rst;
logic frame_ready, first_fill_flag;
logic sdram_waitrequest, sdram_readdatavalid, sdram_read;
logic [255:0] sdram_readdata;
logic [255:0] pixel_out;
logic pixel_req;
int read_in_count;
int pixel_out_count;


// generate clocks
always #10 sdram_clk = ~sdram_clk; // 50 MHz clock with period 20ns
always #3 pixel_clk = ~pixel_clk; // 150 MHz clock with period 6.67 ns


sdram_reader #(
    .SDRAM_DATA_WIDTH (256)
) sdram_reader (

    .sdram_clk              (sdram_clk),
    .pixel_clk              (pixel_clk),
    .rst                    (rst),

    .frame_ready_i          (frame_ready),        // indicate that there is data in sdram, perhaps this is 2 bits
    .first_fill_flag_o      (first_fill_flag),


   .sdram_address_o         (),
   .sdram_burstcount_o      (),
   .sdram_waitrequest_i     (sdram_waitrequest),
   .sdram_readdata_i        (sdram_readdata),
   .sdram_readdatavalid_i   (sdram_readdatavalid),
   .sdram_read_o            (sdram_read),

   .pixel8_req_i            (pixel_req),
   .pixel8_o                (pixel_out)
    );

initial begin
    
    {sdram_clk, pixel_clk, rst} <= 1'b1;
    frame_ready         <= 0;
    pixel_req           <= 0;
    sdram_waitrequest   <= 0;
    pixel_out_count     <= 0;

    repeat (4) @ (posedge sdram_clk);
    rst <= 0;
    repeat (4) @ (posedge sdram_clk);
    frame_ready         <= 1;

    fork 
    begin
        $display("Entering sdram clock block.");
        while (~first_fill_flag) begin
            @( posedge sdram_clk);
        end
        $display("First fill flag triggered.");
        repeat (256) @ (posedge sdram_clk);
    // end

    // begin
        $display("Entering pixel pull block.");
        do begin
            if (first_fill_flag) begin
                pull_out_pixel();
            end
        end while (pixel_out_count <= 1023);
    end

    begin
        while (1) begin
            gen_random_wait();
        end
    end
    join_any


    $stop;

end

// fill the fifo from sdram
always_ff @ (posedge sdram_clk) begin
    if (rst) begin
        read_in_count           <= 0;
        sdram_readdata          <= 0;
        sdram_readdatavalid     <= 0;

    end else begin
        if (~sdram_waitrequest) begin
            if (sdram_read) begin
                sdram_readdata      <= read_in_count;
                sdram_readdatavalid <= 1;
                read_in_count       <= read_in_count + 1;
            end else begin
                sdram_readdata      <= 0;
                sdram_readdatavalid <= 0;
                read_in_count       <= read_in_count;
            end
        end else begin
            sdram_readdata          <= sdram_readdata;
            read_in_count           <= read_in_count;
            sdram_readdatavalid     <= 0;
        end
    end
end


// check to make sure the data out is intact
always_ff @ (posedge pixel_clk) begin
    if (first_fill_flag) begin
        assert (pixel_out == pixel_out_count) 
            else begin
                $error("Assertion mismatch.");
                $stop;
            end
    end
end



task pull_out_pixel();
begin

    @ (posedge pixel_clk);
    pixel_req   <= 1;
    @ (posedge pixel_clk);
    pixel_req   <= 0;
    pixel_out_count <= pixel_out_count + 1;
    repeat ($urandom%10) @ (posedge pixel_clk);

end
endtask


task gen_random_wait();
begin
    @(posedge sdram_clk);
    sdram_waitrequest <= 1;
    repeat ($urandom%3) @ (posedge sdram_clk);
    sdram_waitrequest <= 0;
    repeat ($urandom%8) @ (posedge sdram_clk);
end
endtask

endmodule