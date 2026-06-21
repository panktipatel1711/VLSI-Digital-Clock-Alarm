// =============================================================================
// Module Name:  alarm_fsm
// Description:  Alarm control unit providing identity comparators, 
//               a 60-second auto-timeout ring window, and 5-minute snooze logic.
// =============================================================================
module alarm_fsm (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick_1k,
    input  wire [4:0] hr,
    input  wire [5:0] min,
    input  wire [5:0] sec,
    input  wire [4:0] alm_hr,
    input  wire [5:0] alm_min,
    input  wire       en_level,
    input  wire       snooze_pulse,
    input  wire       stop_pulse,
    output reg        ring_active
);
    reg [4:0] sh;
    reg [5:0] sm;
    reg [5:0] ring_ms;
    reg       in_ring;
    reg       snooze_active;

    reg [9:0] div;
    wire tick_1hz = (tick_1k && (div == 999));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) div <= 0;
        else if (tick_1k) div <= (div == 999) ? 0 : div + 1'b1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sh            <= 0;
            sm            <= 0;
            in_ring       <= 1'b0;
            ring_ms       <= 0;
            ring_active   <= 1'b0;
            snooze_active <= 1'b0;
        end else begin
            if (en_level && !in_ring && !snooze_active && (hr == alm_hr) && (min == alm_min) && (sec == 0)) begin
                in_ring     <= 1'b1;
                ring_active <= 1'b1;
                ring_ms     <= 60;
                sh          <= alm_hr;
                sm          <= alm_min;
            end

            if (snooze_pulse && in_ring) begin
                if (sm >= 55) begin
                    sm <= sm + 5 - 60;
                    sh <= (sh == 23) ? 0 : sh + 1'b1;
                end else begin
                    sm <= sm + 5;
                end
                in_ring       <= 1'b0;
                ring_active   <= 1'b0;
                ring_ms       <= 0;
                snooze_active <= 1'b1;
            end

            if (snooze_active && (hr == sh) && (min == sm) && (sec == 0)) begin
                in_ring       <= 1'b1;
                ring_active   <= 1'b1;
                ring_ms       <= 60;
                snooze_active <= 1'b0;
            end

            if (stop_pulse || !en_level) begin
                in_ring       <= 1'b0;
                ring_active   <= 1'b0;
                ring_ms       <= 0;
                snooze_active <= 1'b0;
            end

            if (in_ring && tick_1hz) begin
                if (ring_ms == 0) begin
                    in_ring     <= 1'b0;
                    ring_active <= 1'b0;
                end else begin
                    ring_ms <= ring_ms - 1'b1;
                end
            end
        end
    end
endmodule
