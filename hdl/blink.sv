// `default_nettype none

module blink (
    input wire      clk,
    output logic    led
);
    reg [26:0] counter;

    always @(posedge clk) counter <= counter + 1'b1;

    assign led = counter[26];
endmodule