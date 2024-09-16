`default_nettype none

module delayed_reset #(
    parameter DELAY_CLK_COUNT = 10_000_000 // 200 ms @ 50 MHz input clock freuqency
    )(
    input wire clk_i,
    input wire rst_i,
    output wire delayed_rst_o
    );

logic [$clog2(DELAY_CLK_COUNT)-1:0] delay_count;

always_ff @ (posedge clk_i) begin
    if (rst_i) begin
        delay_count     <= 0;
        delayed_rst_o   <= 1'b1;
    end else begin
        delayed_rst_o   <= 1'b1;
        if (delay_count == DELAY_CLK_COUNT-1) begin
            delayed_rst_o   <= 1'b0;
        end else begin
            delay_count <= delay_count + 1;
        end 
    end
end


endmodule

`ifdef QUARTUS_ENV
    `default_nettype wire
`endif