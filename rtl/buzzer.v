// =============================================================================
// Module Name:  buzzer
// Description:  Generates audible tone patterns via a fixed-frequency 
//               PWM square-wave output driver.
// =============================================================================
module buzzer (
    input  wire clk,
    input  wire rst_n,
    input  wire tick_1k,
    input  wire enable,
    output reg  buzz_out
);
    reg [9:0] tdiv;
    reg       tone;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tdiv <= 0;
            tone <= 1'b0;
        end else if (tick_1k) begin
            tdiv <= (tdiv == 0) ? 249 : tdiv - 1'b1;
            if (tdiv == 0) tone <= ~tone;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) buzz_out <= 1'b0;
        else        buzz_out <= enable ? tone : 1'b0;
    end
endmodule
