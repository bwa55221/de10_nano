`timescale 1ns/1ps
`default_nettype none

module tb_fifo_unpack();

/// testing a way to unpack pixels from an array


logic [255:0] rgb_fifo_word;
localparam PIXEL_WIDTH = 32;
logic [31:0] current_pixel;



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

for (int i=0; i<$size(rgb_fifo_word)/PIXEL_WIDTH; i++) begin
    current_pixel <= rgb_fifo_word[i*PIXEL_WIDTH+:PIXEL_WIDTH];
    $display ("Current pixel data: %0h", current_pixel);
    #1;
end

$stop;

end



endmodule       