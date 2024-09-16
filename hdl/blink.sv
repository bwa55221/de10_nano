`default_nettype none

module blink (
    input wire      clk,
    input wire      rst,
    output logic    led
);
    reg [26:0] counter;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            counter <= 0;
        end else begin
            counter <= counter + 1'b1;
        end
    end

    assign led = counter[26];
endmodule

`ifdef QUARTUS_ENV
    `default_nettype wire
`endif