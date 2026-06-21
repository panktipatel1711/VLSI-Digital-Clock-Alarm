// =============================================================================
// Module Name:  seg_mux
// Description:  4-Digit Multiplexed 7-Segment display controller with character
//               decoding and field blinking effects during setting modes.
// =============================================================================
module seg_mux (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       tick_1k,
    input  wire [4:0] hr,
    input  wire [5:0] min,
    input  wire       edit_hr,
    input  wire       edit_min,
    input  wire       blink,
    input  wire       mode_12h,
    output reg  [6:0] seg,
    output reg  [3:0] an,
    output reg        colon
);
    wire [4:0] hr_disp = mode_12h ? ((hr == 0) ? 5'd12 : (hr > 12 ? hr - 12 : hr)) : hr;
    wire [3:0] d3 = hr_disp / 10;
    wire [3:0] d2 = hr_disp % 10;
    wire [3:0] d1 = min / 10;
    wire [3:0] d0 = min % 10;

    reg [1:0] idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) idx <= 0;
        else if (tick_1k) idx <= idx + 1'b1;
    end

    function [6:0] enc(input [3:0] x);
        case (x)
            4'h0: enc = 7'b1000000; 4'h1: enc = 7'b1111001; 4'h2: enc = 7'b0100100;
            4'h3: enc = 7'b0110000; 4'h4: enc = 7'b0011001; 4'h5: enc = 7'b0010010;
            4'h6: enc = 7'b0000010; 4'h7: enc = 7'b1111000; 4'h8: enc = 7'b0000000;
            4'h9: enc = 7'b0010000; default: enc = 7'b1111111;
        endcase
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            seg   <= 7'b1111111;
            an    <= 4'b1111;
            colon <= 1'b1;
        end else begin
            colon <= ~blink;
            case (idx)
                2'd0: begin an <= 4'b1110; seg <= (edit_min && blink) ? 7'b1111111 : enc(d0); end
                2'd1: begin an <= 4'b1101; seg <= (edit_min && blink) ? 7'b1111111 : enc(d1); end
                2'd2: begin an <= 4'b1011; seg <= (edit_hr  && blink) ? 7'b1111111 : enc(d2); end
                2'd3: begin an <= 4'b0111; seg <= (edit_hr  && blink) ? 7'b1111111 : enc(d3); end
            endcase
        end
    end
endmodule
