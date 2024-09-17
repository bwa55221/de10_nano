`default_nettype none
// `define ENABLE_TEST_PIXEL
`define QUARTUS_ENV
module hdmi_pixel_driver #(
    parameter PIXEL_FIFO_DATA_WIDTH = 64
)
(
    input wire      clk_i,
    input wire      rst_i,
    input wire      hdmi_tcvr_ready_i,
    input wire      pixel_ready_i,
    input wire      [PIXEL_FIFO_DATA_WIDTH-1:0] pixfifo_word_i,
    output logic     pixfifo_req_o,
    output logic    [23:0] rgb_pixel_o,
    output logic     vsync_o,
    output logic     hsync_o, 
    output logic     data_enable_o,
    output logic [31:0] read_counter_o
);


localparam PIXEL_WIDTH = 32;

// stuff I can pack into a package later /////////////
struct {
    int h_total;
    int h_sync;
    int h_start;
    int h_end;
    int v_total;
    int v_sync;
    int v_start;
    int v_end;
} current_timing;


// these video timings report as 1920x1080 on the HDMI test monitor
// assign current_timing = '{2200, 44, 192, 2112, 1125, 5, 41, 1120}; // DMT timings for 1920x1080p60 results in 1920x1079
assign current_timing = '{2200, 44, 192, 2112, 1125, 5, 40, 1120}; // modified DMT timing to get 1920x1080

/// end package stuff ///////////////////////////


// typedef enum {RESET, REQUEST, PRELOAD, WAIT} state_t;
localparam RESET = 2'b00;
localparam REQUEST = 2'b10;
localparam PRELOAD = 2'b11;
localparam WAIT = 2'b01;
logic [2:0] state, next_state;

logic [$clog2(PIXEL_FIFO_DATA_WIDTH/PIXEL_WIDTH)-1:0] word_pix_count;
logic [PIXEL_FIFO_DATA_WIDTH-1:0] rgb_pixel_q;

logic internal_rst;
logic data_enable, data_enable_q;
assign data_enable_o = data_enable_q;
// video_timing_struct current_timing;
logic [7:0] red, green, blue;
// counters for counting across row/frame
int h_count, v_count;
// for keeping track of active states
logic h_act, h_act_q, v_act, v_act_q;
logic h_max, hs_end, hr_start, hr_end;
logic v_max, vs_end, vr_start, vr_end;
// store current value of timing
int h_total;
int h_sync;
int h_start;
int h_end;
int v_total;
int v_sync;
int v_start;
int v_end;

// some reset logic
logic internal_rst_q;
logic internal_rst_falledge;
assign internal_rst_falledge = internal_rst_q && ~internal_rst;

// assign current_timing = video_timing_array[0];
assign h_total     = current_timing.h_total;
assign h_sync      = current_timing.h_sync;
assign h_start     = current_timing.h_start;
assign h_end       = current_timing.h_end;
assign v_total     = current_timing.v_total;
assign v_sync      = current_timing.v_sync;
assign v_start     = current_timing.v_start;
assign v_end       = current_timing.v_end;

assign rgb_pixel_o = {red, green, blue};

always_comb begin
    h_max       = (h_count==h_total)    ? 1'b1 : 1'b0;
    hs_end      = (h_count >= h_sync)   ? 1'b1 : 1'b0;
    hr_start    = (h_count == h_start)  ? 1'b1 : 1'b0; // activate column
    hr_end      = (h_count == h_end)    ? 1'b1 : 1'b0; // de-activate column

    v_max       = (v_count == v_total)  ? 1'b1 : 1'b0;
    vs_end      = (v_count >= v_sync)   ? 1'b1 : 1'b0;
    vr_start    = (v_count == v_start)  ? 1'b1 : 1'b0; // activate row
    vr_end      = (v_count == v_end)    ? 1'b1 : 1'b0; // de-activate row

    internal_rst    = (rst_i || ~hdmi_tcvr_ready_i || ~pixel_ready_i);
end

always_ff @ (posedge clk_i) begin
    internal_rst_q  <= internal_rst;
end

logic [7:0] test_pixel;

// horizontal / column control
always_ff @ (posedge clk_i) begin
    if (internal_rst) begin
        h_act   <= 0;
        h_act_q <= 0;
        h_count <= 0;
        hsync_o <= 0;
        test_pixel  <= 0;
    end else begin

        h_act_q <= h_act;

    // reset counter if end of row
        if (h_max) begin 
            h_count <= 0;
        end else begin
            // h_count++;
            h_count <= h_count + 1;
        end

    // send sync if end of row
        if (hs_end && ~h_max) begin
            hsync_o    <= 0;
        end else begin
            hsync_o    <= 1;
        end
    
    // activate horizontal column selector
        if (hr_start) begin
            h_act   <= 1;
        end else if (hr_end) begin
            h_act   <= 0;
        end else begin
            h_act   <= h_act;
        end

    // test pixel assignment
        if (h_act_q) begin
            test_pixel <= test_pixel + 1;
        end else begin
            test_pixel <= 0;
        end

    end
end

// vertical / row control
always_ff @ (posedge clk_i) begin
    if (internal_rst) begin
        v_act       <= 0;
        v_act_q     <= 0;
        v_count     <= 0;
        vsync_o    <= 0;
    end else begin
        if (h_max) begin
            v_act_q     <= v_act;

            if (v_max) begin
                v_count <= 0;
            end else begin
                v_count <= v_count + 1;
            end

            if (vs_end && ~v_max) begin
                vsync_o    <= 0;
            end else begin
                vsync_o    <= 1;
            end

            if (vr_start) begin
                v_act   <= 1;
            end else if (vr_end) begin
                v_act   <= 0;
            end else begin
                v_act   <= v_act;
            end
        end
    end 
end

// manage data enable signal
always_ff @ (posedge clk_i) begin
    if (internal_rst) begin
        {data_enable, data_enable_q}    <= {1'b0, 1'b0};
        {red, green, blue}              <= {8'b0, 8'b0, 8'b0};
    end else begin

        data_enable_q   <= data_enable;
        
        if (v_act && h_act) begin            
            data_enable <= 1;
        end else begin
            data_enable <= 0;
        end

        if (data_enable) begin
            `ifdef ENABLE_TEST_PIXEL
                red     <= test_pixel;
                green   <= 8'b0;
                blue    <= 8'b0;
            `else  

                // use this if pixels are packed in via big-endian (MSB first)
                // red     <= 8'(rgb_pixel_q >> (word_pix_count*PIXEL_WIDTH)+24);
                // green   <= 8'(rgb_pixel_q >> (word_pix_count*PIXEL_WIDTH)+16);
                // blue    <= 8'(rgb_pixel_q >> (word_pix_count*PIXEL_WIDTH)+8);

                // pixels are packed in LSB first (little-endian from Intel CPU machine)
                red     <= 8'(rgb_pixel_q >> (word_pix_count*PIXEL_WIDTH));
                green   <= 8'(rgb_pixel_q >> (word_pix_count*PIXEL_WIDTH)+8);
                blue    <= 8'(rgb_pixel_q >> (word_pix_count*PIXEL_WIDTH)+16);

            `endif
        end else begin
            {red, green, blue}  <= {8'b0, 8'b0, 8'b 0};
        end

    end 
end
logic delay_clk;
// only align this to be reset pending the pixel ready biy
always_ff @ (posedge clk_i) begin
    if (~pixel_ready_i) begin
        pixfifo_req_o   <= 0;
        word_pix_count  <= 0;
        rgb_pixel_q     <= 0;
        delay_clk       <= 0;
    end else begin

        if (state == REQUEST) begin
            pixfifo_req_o   <= 1;

        end else if (state == PRELOAD) begin
            delay_clk       <= 1;
            pixfifo_req_o   <= 0;
            rgb_pixel_q     <= pixfifo_word_i;
        

        end else if (data_enable_o) begin 

            word_pix_count  <= word_pix_count + 1;

            if (word_pix_count == (PIXEL_FIFO_DATA_WIDTH/PIXEL_WIDTH) - 4) begin
                pixfifo_req_o   <= 1;

            end else if (word_pix_count == (PIXEL_FIFO_DATA_WIDTH/PIXEL_WIDTH) - 3) begin
                pixfifo_req_o   <= 0;

            end else if (word_pix_count == (PIXEL_FIFO_DATA_WIDTH/PIXEL_WIDTH) - 2) begin
                rgb_pixel_q     <= pixfifo_word_i;

            end else begin
                pixfifo_req_o   <= 0;
            end
        
        end else begin    
            pixfifo_req_o       <= 0;
        end

    end
end

// count the number of read requests per frame
always_ff @ (posedge clk_i) begin
    if (rst_i || vsync_o) begin
        read_counter_o <= 0;
    end else begin
        if (pixfifo_req_o) begin
            read_counter_o <= read_counter_o + 1;
        end
    end
end

// state machine for managing the preloading of the fifo

// compiler wasn't recongnizing this state machine
// typedef enum {RESET, REQUEST, PRELOAD, WAIT} state_t;
// state_t state, next_state;

always_ff @ (posedge clk_i) begin

    if (~pixel_ready_i) begin
        state   <= RESET;
    end else begin
        state   <= next_state;
    end
end

always_comb begin
    case (state) 
    RESET: begin
        next_state <= REQUEST;
    end

    REQUEST: begin
        next_state  <= PRELOAD;
    end

    PRELOAD: begin
        if (delay_clk) begin
            next_state  <= WAIT;
        end else begin
            next_state <= PRELOAD;
        end
    end

    WAIT: begin
        next_state <= WAIT;
    end

    endcase
end

endmodule

// do this to make quartus not break
`ifdef QUARTUS_ENV
    `default_nettype wire
`endif