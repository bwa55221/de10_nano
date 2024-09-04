`timescale 1ns/1ps
`default_nettype none

module tb_fifo_unpack();

/// testing a way to unpack pixels from an array


logic [255:0] rgb_fifo_word;
localparam PIXEL_WIDTH = 32;
logic [31:0] current_pixel;

logic [7:0] red;
logic [7:0] green;
logic [7:0] blue;
// logic [7:0] {red, green, blue};



initial begin
    current_pixel <= 0;
    rgb_fifo_word <= {$urandom(),
                    $urandom(),
                    $urandom(),
                    $urandom(),
                    $urandom(),
                    $urandom(),
                    $urandom(),
                    $urandom()};
    #5;


    for (int i=0; i<8; i++) begin

        current_pixel <= (rgb_fifo_word >> i*PIXEL_WIDTH);
        red             <= (rgb_fifo_word >> (i*PIXEL_WIDTH)+24);
        green           <= (rgb_fifo_word >> (i*PIXEL_WIDTH)+16);
        blue            <= (rgb_fifo_word >> (i*PIXEL_WIDTH)+8);
        // current_pixel <= rgb_fifo_word[i*PIXEL_WIDTH+:PIXEL_WIDTH];
        $display("Current pixel data for pixel %0d: %0h", i, current_pixel);
        #1;

    end

$stop;

end



endmodule       