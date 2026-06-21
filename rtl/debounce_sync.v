// =============================================================================
// Module Name:  debounce_sync
// Description:  2-stage Flip-Flop Synchronizer and Debouncer for asynchronous 
//               pushbutton inputs to eliminate metastability and switch bounces.
// =============================================================================
module debounce_sync #(
    parameter integer TICKS = 5
)(
    input  wire clk,
    input  wire rst_n,
    input  wire tick_1k,
    input  wire async_in,
    output reg  pulse,
    output reg  level
);
    reg s1, s2;
    always @(posedge clk) begin
        {s1, s2} <= {async_in, s1};
    end

    reg [$clog2(TICKS+1)-1:0] db;
    reg stable;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            db     <= 0;
            stable <= 0;
            level  <= 0;
            pulse  <= 0;
        end else begin
            pulse <= 0;
            if (tick_1k) begin
                if (s2 != stable) begin
                    db <= db + 1'b1;
                    if (db == TICKS) begin
                        stable <= s2;
                        db     <= 0;
                    end
                end else begin
                    db <= 0;
                end
                
                if (stable && !level) begin
                    level <= 1'b1;
                    pulse <= 1'b1;
                end else if (!stable) begin
                    level <= 1'b0;
                end
            end
        end
    end
endmodule
