module hdmi_pixel_driver #(
    parameter PIXEL_FIFO_DATA_WIDTH = 64
)
(
    input wire      clk_i,
    input wire      rst_i,
    input wire      hdmi_tcvr_ready_i,
    input wire      pixel_ready_i,
    input wire      [PIXEL_FIFO_DATA_WIDTH-1:0] pixfifo_word_i,
    output wire     pixfifo_req_o,
    output logic    [23:0] rgb_pixel_o,
    output wire     vsync_o,
    output wire     hsync_o, 
    output wire     data_enable_o
);

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


// 1920x1080p60 148.5 MHz
// assign video_timing_array[0] = '{2199, 43, 189, 2109, 1124, 4, 45, 1120};
assign current_timing = '{2199, 43, 189, 2109, 1124, 4, 45, 1120};
/// end package stuff ///////////////////////////


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
    h_max       = (h_count==h_total)    ? 1 : 0;
    hs_end      = (h_count >= h_sync)   ? 1 : 0;
    hr_start    = (h_count == h_start)  ? 1 : 0; // activate column
    hr_end      = (h_count == h_end)    ? 1 : 0; // de-activate column

    v_max       = (v_count == v_total)  ? 1 : 0;
    vs_end      = (v_count >= v_sync)   ? 1 : 0;
    vr_start    = (v_count == v_start)  ? 1 : 0; // activate row
    vr_end      = (v_count == v_end)    ? 1 : 0; // de-activate row
end


// horizontal / column control
always_ff @ (posedge clk_i) begin
    if (rst_i) begin
        h_act   <= 0;
        h_act_q <= 0;
        h_count <= 0;
        hsync_o <= 0;
    end else begin

        h_act_q <= h_act;

    // reset counter if end of row
        if (h_max) begin 
            h_count <= 0;
        end else begin
            h_count++;
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
    end
end

// vertical / row control
always_ff @ (posedge clk_i) begin
    if (rst_i) begin
        v_act       <= 0;
        v_act_q     <= 0;
        v_count     <= 0;
        vsync_o    <= 0;
    end else begin

        v_act_q     <= v_act;

        if (v_max) begin
            v_count <= 0;
        end else begin
            v_count++;
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

// manage data enable signal
always_ff @ (posedge clk_i) begin
    if (rst_i || ~hdmi_tcvr_ready_i || ~pixel_ready_i) begin
        data_enable_o   <= 0;
        {red, green, blue}  <= {0, 0, 0};
    end else begin
        if (v_act && h_act) begin
            
            data_enable_o <= 1;

            if (~word_pix_count) begin
                red     <= rgb_pixel_q[31:24];
                green   <= rgb_pixel_q[23:16];
                blue    <= rgb_pixel_q[15:8];
            end else begin
                red     <= rgb_pixel_q[63:56];
                green   <= rgb_pixel_q[55:48];
                blue    <= rgb_pixel_q[47:40];
            end
        end else begin

            data_enable_o <= 0;
            {red, green, blue}  <= {0, 0, 0};
        end
    end 
end

// this should be large enough to hold num pix per word
// currently only 2 pixels per word so this is just 1 bit logic
logic word_pix_count;
logic [PIXEL_FIFO_DATA_WIDTH-1:0] rgb_pixel_q;

always_ff @ (posedge clk_i) begin
    if (rst_i || ~pixel_ready_i) begin
        pixfifo_req_o   <= 0;
        word_pix_count  <= 0;
        rgb_pixel_q     <= 0;
    end else begin

        // increment current pixel count only when data_enable is active
        if (data_enable_o) begin
            word_pix_count++;
        end

        // send a pixel request every other pixel (2 pixels per word rn)
        if (word_pix_count == 1) begin
            pixfifo_req_o   <= 1;
        end else begin
            pixfifo_req_o   <= 0;
            rgb_pixel_q     <= pixfifo_word_i;
        end
    end
end

endmodule