// =============================================================================
// Module Name:  clk_en
// Description:  Parameterized clock enable generator to maintain single-domain 
//               synchronous design. Avoids glitch-prone gated clocks.
// =============================================================================
module clk_en #(
    parameter integer CLK_HZ  = 50_000_000,
    parameter integer TICK_HZ = 1000
)(
    input  wire clk,
    input  wire rst_n,
    output reg  tick
);
    localparam integer DIV = CLK_HZ / TICK_HZ;
    reg [$clog2(DIV)-1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt  <= 0;
            tick <= 1'b0;
        end else begin
            tick <= 1'b0;
            if (cnt == DIV - 1) begin
                cnt  <= 0;
                tick <= 1'b1;
            end else begin
                cnt  <= cnt + 1'b1;
            end
        end
    end
endmodule
