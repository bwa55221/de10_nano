//`default_nettype none

module test_st_sink #(
    parameter DATA_WIDTH = 256
    ) (
        input wire clk,
        input wire rst,
        input wire [DATA_WIDTH-1:0] st_data,
        input wire valid,
        output logic ready
);
logic [DATA_WIDTH-1:0] data_q; // register the data array

always_ff @ (posedge clk) begin
    if (rst) begin
        data_q  <= 0;
        ready   <= 0;
    end else begin
        ready   <= 1;
        data_q  <= st_data;
    end
end

endmodule
