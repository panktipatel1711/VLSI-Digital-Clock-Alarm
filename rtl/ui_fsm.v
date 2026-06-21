// =============================================================================
// Module Name:  ui_fsm
// Description:  Finite State Machine managing button-controlled system modes
//               (View, Set Time, Set Alarm, Format Toggle).
// =============================================================================
module ui_fsm (
    input  wire clk,
    input  wire rst_n,
    input  wire mode_pulse,
    input  wire up_pulse,
    input  wire down_pulse,
    input  wire alarm_en_toggle,
    input  wire snooze_pulse,
    output reg  set_mode,
    output reg  edit_hr,
    output reg  edit_min,
    output reg  mode_12h,
    output reg  inc_hr,
    output reg  inc_min,
    output reg  inc_sec,
    output reg  alm_en_latched,
    output reg  stop_pulse_out,
    output reg  snooze_pulse_out,
    output reg  edit_alm_active
);
    localparam S_VIEW      = 2'd0;
    localparam S_SET_TIME  = 2'd1;
    localparam S_SET_ALARM = 2'd2;
    localparam S_FMT       = 2'd3;

    reg [1:0] s;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s                <= S_VIEW;
            mode_12h         <= 1'b0;
            alm_en_latched   <= 1'b0;
            set_mode         <= 1'b0;
            edit_hr          <= 1'b0;
            edit_min         <= 1'b0;
            edit_alm_active  <= 1'b0;
            {inc_hr, inc_min, inc_sec} <= 3'b000;
            stop_pulse_out   <= 1'b0;
            snooze_pulse_out <= 1'b0;
        end else begin
            {inc_hr, inc_min, inc_sec} <= 3'b000;
            stop_pulse_out   <= 1'b0;
            snooze_pulse_out <= 1'b0;

            if (mode_pulse) s <= s + 1'b1;

            if (alarm_en_toggle) alm_en_latched <= ~alm_en_latched;

            case (s)
                S_VIEW: begin
                    set_mode        <= 1'b0;
                    edit_hr         <= 1'b0;
                    edit_min        <= 1'b0;
                    edit_alm_active <= 1'b0;
                    if (down_pulse) stop_pulse_out <= 1'b1;
                    snooze_pulse_out <= snooze_pulse;
                end
                S_SET_TIME: begin
                    set_mode <= 1'b1;
                    edit_hr  <= 1'b1;
                    edit_min <= 1'b1;
                    if (up_pulse)   inc_min <= 1'b1;
                    if (down_pulse) inc_hr  <= 1'b1;
                end
                S_SET_ALARM: begin
                    edit_alm_active <= 1'b1;
                    if (up_pulse)   inc_min <= 1'b1;
                    if (down_pulse) inc_hr  <= 1'b1;
                end
                S_FMT: begin
                    edit_alm_active <= 1'b0;
                    set_mode        <= 1'b0;
                    edit_hr         <= 1'b0;
                    edit_min        <= 1'b0;
                    if (up_pulse || down_pulse) mode_12h <= ~mode_12h;
                end
            endcase
        end
    end
endmodule
