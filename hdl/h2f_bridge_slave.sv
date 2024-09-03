module h2f_bridge_slave #(
    parameter H2F_ADDRWIDTH = 10,
    parameter H2F_DATAWIDTH = 64,
    parameter TOTREG       = 32
    )(
    input                           clk,
    input                           rst,
    input                           read,
    input                           write,
    input [H2F_ADDRWIDTH-1:0    ]   address,
    input [H2F_DATAWIDTH-1:0    ]   writedata,
    input [(H2F_DATAWIDTH/8)-1:0]   byteenable,
    input                           burstcount,
    output [H2F_DATAWIDTH-1:0   ]   readdata,
    output                          readdatavalid,
    output                          waitrequest,

    input   wire    [$clog2(TOTREG)-1:0]    fabric_regsel_i,
    output  logic   [H2F_DATAWIDTH-1:0]     fabric_regdata_o
);


localparam BASE_OFFSET = 0;
localparam BYTE_COUNT = H2F_DATAWIDTH/8;

/* AVALON SLAVE CONTROL LOGIC */

logic read_reg0, read_reg1, read_reg2, read_reg3;
logic write_reg0, write_reg1, write_reg2, write_reg3;
logic internal_write_flag, internal_read_flag;
logic internal_read_flag_q, internal_write_flag_q;
logic internal_read_flag_rise, internal_write_flag_rise;
logic write_rise;
logic avmm_write_strobe;
logic [$clog2(TOTREG)-1:0] register_idx;
wire [H2F_DATAWIDTH-1:0] regdata_out [TOTREG-1:0];
wire [H2F_DATAWIDTH-1:0] regdata_in  [TOTREG-1:0];
wire wr_en [TOTREG-1:0];
logic [H2F_DATAWIDTH-1:0]     rst_data    [TOTREG-1:0];


// "inside" is only available in SystemVerilog
// assign register_idx = address inside {[32'h0:32'h0 + TOTREG*BYTE_COUNT]} ? (address - BASE_OFFSET) >> 2 : 0;
assign register_idx = (address >= 0 && address <= TOTREG*BYTE_COUNT) ? (address - BASE_OFFSET) >> 2 : 0;
assign write_rise = write & !write_reg0;  // rising edge detection
assign internal_write_flag_rise = internal_write_flag & !internal_write_flag_q;
assign internal_read_flag_rise  = internal_read_flag & !internal_read_flag_q;

// readback logic
always_comb begin
    readdatavalid = internal_read_flag ? 1 : 0;
    readdata = ~write ? regdata_out[register_idx]: 0;
end

// write logic
always_ff @ (posedge clk) begin

    if (rst) begin

        regdata_in[register_idx] <= rst_data[register_idx];

    end else begin
        if (write) begin
            for (int i=0; i < $size(byteenable); i++) begin
                if (byteenable[i] == 1) begin
                    regdata_in[register_idx][((i+1)*8)-1-:8] <= writedata[((i+1)*8)-1-:8];
                end
            end  
        
        // latch removal
        end else begin
            regdata_in[register_idx]    <= regdata_in[register_idx];
        end
    end
end

// write enable control, avoiding latch inference
always_comb begin
    for (int i=0; i<TOTREG; i++) begin
        wr_en[i] = 0;
    end

    if (write) begin
        wr_en[register_idx] = 1;
    end
end


// registering of R/W flags from AVMM master, detection write rising edge
always_ff @ (posedge clk) begin
    if (rst) begin
        {read_reg0, read_reg1, read_reg2, read_reg3}        <= 4'b0;
        {write_reg0, write_reg1, write_reg2, write_reg3}    <= 4'b0;
        avmm_write_strobe                                   <= 1'b0;

    end else begin

        read_reg0 <= read;
        read_reg1 <= read_reg0;
        read_reg2 <= read_reg1;
        read_reg3 <= read_reg2;

        write_reg0 <= write;
        write_reg1 <= write_reg0;
        write_reg2 <= write_reg1;
        write_reg3 <= write_reg2;

        if (read == 0) begin
            {read_reg0, read_reg1, read_reg2, read_reg3}        <= 4'b0;
        end

        if (write_rise) begin
            avmm_write_strobe <= 1;
        end else begin
            avmm_write_strobe <= 0;
        end

    end
end

// manage internal read and write flags
always_comb begin
    if (read && read_reg0 && read_reg1 && read_reg2 && read_reg3) begin
        internal_read_flag = 1;
    end else begin
        internal_read_flag = 0;
    end

    if (write &&write_reg0 && write_reg1 && write_reg2 && write_reg3) begin
        internal_write_flag = 1;
    end else begin
        internal_write_flag = 0;
    end
end

// manage wait request
always_comb begin
    // if (internal_write_flag || internal_read_flag) begin
    if (internal_read_flag_rise || internal_write_flag_rise) begin
        waitrequest = 0;
    end else begin
        waitrequest = 1;
    end
end

// generate reset data  (POTENTIALLY USE THIS FOR PRESETTING WITH VALUES FROM A PACKGE??)
    always_comb begin
        for (int i = 0; i < TOTREG; i++) begin
            rst_data[i] = 0;
        end
    end

// generate registers
    genvar i;
    generate
        for (i=0; i<TOTREG; i++) begin : genregs// replacing "genvar" with "int" for i initiation
            register64 u_reg64 (
                .i_clk     (clk),
                .i_arstn   (~rst),
                .i_rst_data(rst_data[i]),
                .i_wr      (wr_en[i]),
                .i_data    (regdata_in[i]),
                .o_data    (regdata_out[i])
            );
        end
    endgenerate


// provide register data to FPGA fabric
    assign fabric_regdata_o = regdata_out[fabric_regsel_i];

endmodule
