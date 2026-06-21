# =============================================================================
# File Name:    physical_pins.xdc
# Target Board: AMD Artix-7 FPGA Implementation Matrix Configurations
# =============================================================================
set_property PACKAGE_PIN W5 [get_ports clk_50m]
set_property IOSTANDARD LVCMOS33 [get_ports clk_50m]

set_property PACKAGE_PIN V17 [get_ports rst_btn]
set_property IOSTANDARD LVCMOS33 [get_ports rst_btn]

set_property PACKAGE_PIN T18 [get_ports btn_mode]
set_property IOSTANDARD LVCMOS33 [get_ports btn_mode]
set_property PACKAGE_PIN W19 [get_ports btn_up]
set_property IOSTANDARD LVCMOS33 [get_ports btn_up]
set_property PACKAGE_PIN T17 [get_ports btn_down]
set_property IOSTANDARD LVCMOS33 [get_ports btn_down]
set_property PACKAGE_PIN U17 [get_ports btn_alarm]
set_property IOSTANDARD LVCMOS33 [get_ports btn_alarm]
set_property PACKAGE_PIN M19 [get_ports btn_snooze]
set_property IOSTANDARD LVCMOS33 [get_ports btn_snooze]

set_property PACKAGE_PIN W7 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property PACKAGE_PIN W6 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property PACKAGE_PIN U8 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property PACKAGE_PIN V5 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property PACKAGE_PIN U7 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]

set_property PACKAGE_PIN U2 [get_ports {an[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[0]}]
set_property PACKAGE_PIN U4 [get_ports {an[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[1]}]
set_property PACKAGE_PIN V4 [get_ports {an[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[2]}]
set_property PACKAGE_PIN W4 [get_ports {an[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {an[3]}]

set_property PACKAGE_PIN V14 [get_ports colon]
set_property IOSTANDARD LVCMOS33 [get_ports colon]

set_property PACKAGE_PIN A14 [get_ports buzzer]
set_property IOSTANDARD LVCMOS33 [get_ports buzzer]
