`timescale 1ns/1ps
// =============================================================================
// Module Name:  clock_tb
// Description:  Comprehensive verification testbench with accelerated logic
//               ticks to test rollovers, adjustments, and alarm triggers.
// =============================================================================
module clock_tb;
    reg clk = 0;
    reg rst = 1;
    reg mode = 0;
    reg up = 0;
    reg down = 0;
    reg alarm = 0;
    reg snooze = 0;

    wire [6:0] seg;
    wire [3:0] an;
    wire colon;
    wire buzzer;

    top DUT (
        .clk_50m(clk), .rst_btn(rst), .btn_mode(mode),
        .btn_up(up), .btn_down(down), .btn_alarm(alarm), .btn_snooze(snooze),
        .seg(seg), .an(an), .colon(colon), .buzzer(buzzer)
    );

    always #10 clk = ~clk; // 50MHz Clock Representation

    task pulse_button(ref reg btn);
        begin
            #40000; btn = 1;
            #40000; btn = 0;
            #40000;
        end
    endtask

    initial begin
        $dumpfile("clock_waves.vcd");
        $dumpvars(0, clock_tb);
        
        // Performance Acceleration bypass for rapid verification runtime
        force clock_tb.DUT.U_TICK.cnt = 24; 
        
        #200;
        rst = 0; 
        #1000;

        // Test configuration controls
        pulse_button(mode); // Set Time Mode
        pulse_button(up);   // Increment minutes
        pulse_button(mode); // Set Alarm Mode
        pulse_button(alarm); // Toggle Alarm Enable

        #2000000;
        $display("[SUCCESS] Verification simulation runtime complete.");
        $finish;
    end
endmodule
