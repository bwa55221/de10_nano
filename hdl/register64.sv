`default_nettype none

module register64 (
    input  wire       i_clk,
    input  wire       i_arstn,
    input  wire logic [63:0] i_rst_data,
    input  wire       i_wr,
    input  wire logic [63:0] i_data,
    output wire logic [63:0] o_data
);

  logic [63:0] reg64;

  always_ff @(posedge i_clk or negedge i_arstn) begin
    if (!i_arstn) begin
      reg64 <= i_rst_data;
    end else if (i_wr) begin
      reg64 <= i_data;
    end
  end

  assign o_data = reg64;

endmodule

`ifdef QUARTUS_ENV
    `default_nettype wire
`endif