`default_nettype none

module register32 (
    input  wire       i_clk,
    input  wire       i_arstn,
    input  wire logic [31:0] i_rst_data,
    input  wire       i_wr,
    input  wire logic [31:0] i_data,
    output wire logic [31:0] o_data
);

  logic [31:0] reg32;

  always_ff @(posedge i_clk or negedge i_arstn) begin
    if (!i_arstn) begin
      reg32 <= i_rst_data;
    end else if (i_wr) begin
      reg32 <= i_data;
    end
  end

  assign o_data = reg32;

endmodule

`ifdef QUARTUS_ENV
    `default_nettype wire
`endif