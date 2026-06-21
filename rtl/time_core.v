// =============================================================================
// Module Name:  time_core
// Description:  Core timekeeping engine managing Cascaded Modulo Counters 
//               for Hours (0-23), Minutes (0-59), and Seconds (0-59).
// =============================================================================
module time_core (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick_1k,
    input  wire       set_mode,
    input  wire       inc_sec,
    input  wire       inc_min,
    input  wire       inc_hr,
    input  wire       mode_12h,
    output reg  [5:0] sec,
    output reg  [5:0] min,
    output reg  [4:0] hr,
    output reg        blink_1hz
);
    reg [9:0] div;
    reg       tick_1hz;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div      <= 0;
            tick_1hz <= 1'b0;
        end else if (tick_1k) begin
            tick_1hz <= (div == 999);
            div      <= (div == 999) ? 0 : div + 1'b1;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            blink_1hz <= 1'b0;
        end else if (tick_1hz) begin
            blink_1hz <= ~blink_1hz;
        end
    end

    wire adv_sec = tick_1hz & ~set_mode;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sec <= 0;
            min <= 0;
            hr  <= 0;
        end else begin
            if (inc_sec) sec <= (sec == 59) ? 0 : sec + 1'b1;
            if (inc_min) min <= (min == 59) ? 0 : min + 1'b1;
            if (inc_hr)  hr  <= (hr == 23)  ? 0 : hr + 1'b1;

            if (adv_sec) begin
                if (sec == 59) begin
                    sec <= 0;
                    if (min == 59) begin
                        min <= 0;
                        hr  <= (hr == 23) ? 0 : hr + 1'b1;
                    end else begin
                        min <= min + 1'b1;
                    end
                end else begin
                    sec <= sec + 1'b1;
                end
            end
        end
    end
endmodule
