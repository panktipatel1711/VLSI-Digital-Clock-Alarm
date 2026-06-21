// =============================================================================
// Module Name:  top
// Description:  Top-level integration wiring system ticks, debouncers, 
//               UI finite state machines, memory registers, and display drivers.
// =============================================================================
module top (
    input  wire       clk_50m,
    input  wire       rst_btn,
    input  wire       btn_mode,
    input  wire       btn_up,
    input  wire       btn_down,
    input  wire       btn_alarm,
    input  wire       btn_snooze,
    output wire [6:0] seg,
    output wire [3:0] an,
    output wire       colon,
    output wire       buzzer
);
    wire rst_n = ~rst_btn;
    wire tick_1k;

    clk_en #(.CLK_HZ(50_000_000), .TICK_HZ(1000)) U_TICK (
        .clk(clk_50m), .rst_n(rst_n), .tick(tick_1k)
    );

    wire pmode, pup, pdown, palarm, psnooze;
    debounce_sync D_MO (.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .async_in(btn_mode),   .pulse(pmode));
    debounce_sync D_UP (.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .async_in(btn_up),     .pulse(pup));
    debounce_sync D_DN (.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .async_in(btn_down),   .pulse(pdown));
    debounce_sync D_AL (.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .async_in(btn_alarm),  .pulse(palarm));
    debounce_sync D_SN (.clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .async_in(btn_snooze), .pulse(psnooze));

    wire set_mode, edit_hr, edit_min, mode_12h, inc_hr, inc_min, inc_sec;
    wire alm_en, stop_pulse, snooze_pulse, edit_alm;
    
    ui_fsm U_FSM (
        .clk(clk_50m), .rst_n(rst_n),
        .mode_pulse(pmode), .up_pulse(pup), .down_pulse(pdown),
        .alarm_en_toggle(palarm), .snooze_pulse(psnooze),
        .set_mode(set_mode), .edit_hr(edit_hr), .edit_min(edit_min), .mode_12h(mode_12h),
        .inc_hr(inc_hr), .inc_min(inc_min), .inc_sec(inc_sec),
        .alm_en_latched(alm_en), .stop_pulse_out(stop_pulse), .snooze_pulse_out(snooze_pulse),
        .edit_alm_active(edit_alm)
    );

    reg [4:0] alm_hr;
    reg [5:0] alm_min;
    
    always @(posedge clk_50m or negedge rst_n) begin
        if (!rst_n) begin
            alm_hr  <= 5'd7;
            alm_min <= 6'd0;
        end else if (edit_alm) begin
            if (inc_hr)  alm_hr  <= (alm_hr  == 23) ? 0 : alm_hr  + 1'b1;
            if (inc_min) alm_min <= (alm_min == 59) ? 0 : alm_min + 1'b1;
        end
    end

    wire [5:0] sec, min;
    wire [4:0] hr;
    wire blink;

    time_core U_TIME (
        .clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k),
        .set_mode(set_mode), .inc_sec(inc_sec && !edit_alm), 
        .inc_min(inc_min && !edit_alm), .inc_hr(inc_hr && !edit_alm),
        .mode_12h(mode_12h), .sec(sec), .min(min), .hr(hr), .blink_1hz(blink)
    );

    wire ring;
    alarm_fsm U_ALM (
        .clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k),
        .hr(hr), .min(min), .sec(sec), .alm_hr(alm_hr), .alm_min(alm_min),
        .en_level(alm_en), .snooze_pulse(snooze_pulse), .stop_pulse(stop_pulse),
        .ring_active(ring)
    );

    buzzer U_BUZZ (
        .clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k), .enable(ring), .buzz_out(buzzer)
    );

    seg_mux U_DISP (
        .clk(clk_50m), .rst_n(rst_n), .tick_1k(tick_1k),
        .hr(hr), .min(min), .edit_hr(edit_hr), .edit_min(edit_min),
        .blink(blink), .mode_12h(mode_12h), .seg(seg), .an(an), .colon(colon)
    );
endmodule
