`default_nettype none

/*
Implement a rotation mode CORDIC algorithm

*/

module cordic #(
    parameter NUM_STAGES = 32
)(
    input   wire clk,
    input   wire rst,
    input   signed [31:0] angle,
    input   signed [NUM_STAGES-1:0] x_i,
    input   signed [NUM_STAGES-1:0] y_i,
    output  signed [NUM_STAGES-1:0] x_o,
    output  signed [NUM_STAGES-1:0] y_o
);



// from Wiki:

// take in an input angle (fixed point/Q-format) -- how many bits is this? 

// table of arctangent values from 2^0 to 2^numbits-1

// the number of stages is given by the number of bits of angular resolution



endmodule