# VLSI-Based Digital Clock with Alarm Functionality

## 📌 Project Overview
An industry-oriented, production-grade synchronous **Digital Clock with Alarm and Snooze Functionality** implemented in synthesizable Verilog HDL. This architecture leverages a strict single-clock-domain design with parameterized clock enables to circumvent clock skew and timing violations typical of multi-clock or gated-clock designs. 

The project incorporates structural clock dividers, asynchronous pushbutton synchronization, metastability isolation filtering, a finite state machine (FSM) user interface, and dynamic resource-shared multi-digit 7-segment multiplexing.

---

## 🛠️ Key Structural Design Features
* **Single-Clock Domain Integration:** All system registers trigger on the global high-frequency hardware clock (`clk_50m`), driven by a single synchronous `wire` enable tick network.
* **Metastability & Debounce Isolation:** Implements a 2-stage Flip-Flop Synchronizer alongside a structural accumulation verification filter on all asynchronous pushbutton boundaries.
* **60-Second Auto-Timeout Window:** The alarm control block uses an active down-counter that auto-terminates the ringing state after 60 seconds if left unattended.
* **Advanced Snooze Logic:** Activating snooze temporarily shifts and latches the underlying operational register boundary by +5 minutes, accounting for base-60 temporal wrap-around loops.
* **Dynamic Time-Multiplexed Display:** A high-frequency scanning block multiplexes a shared 7-bit bus across 4 display anodes at 250Hz per digit to eliminate human-eye flicker while saving physical FPGA pin overhead.

---

## 📐 System Architecture Diagram
[ 50 MHz Clock Input ]
                       │
                       ▼
              [ clk_en Module ] 
                       │ (1 kHz Internal Synchronous Tick Enable)
                       ▼
[ Asynchronous Buttons ] ──► [ debounce_sync ] ──► [ ui_fsm Module ]
                                                        │
                                                        ▼
                                               [ time_core Engine ]
                                                        │
                                                        ▼
[ Audio Output Pin ] ◄── [ buzzer PWM ] ◄── [ alarm_fsm ] ◄── [ Comparator ]
│
▼
[ Display Outputs ] ◄────────────────── [ seg_mux Driver ]


---

## 🔌 Hardware Pin & Signal Map Specification

| Port Name | Direction | Data Width | Domain / Clock Ref | Hardware IO Description |
| :--- | :---: | :---: | :---: | :--- |
| `clk_50m` | Input | 1-bit | Master Source | Global Hardware System Clock (50 MHz) |
| `rst_btn` | Input | 1-bit | Asynchronous | Master Active-High Hardware Reset Button |
| `btn_mode` | Input | 1-bit | Asynchronous | Mode Selection Toggle (View -> Time -> Alarm -> Format) |
| `btn_up` | Input | 1-bit | Asynchronous | Parameter Configuration Step Increment Trigger |
| `btn_down` | Input | 1-bit | Asynchronous | Parameter Step Decrement / Latch Clear Signal |
| `btn_alarm` | Input | 1-bit | Asynchronous | Active Alarm Enable System Latch Control |
| `btn_snooze` | Input | 1-bit | Asynchronous | +5 Minute Alarm Postponement Interrupt |
| `seg[6:0]` | Output | 7-bit | Synchronous | Time-Shared Cathode Control Driver Bus (Active Low) |
| `an[3:0]` | Output | 4-bit | Synchronous | Display Anode Power Configuration Multiplexer Lines |
| `colon` | Output | 1-bit | Synchronous | 1 Hz Secondary Visual Temporal Separator Signal |
| `buzzer` | Output | 1-bit | Synchronous | Fixed-Frequency Square Wave Audio Alert Signal |

---

## 🗂️ Verification & Project Folder Hierarchy

```text
VLSI-Digital-Clock-Alarm/
├── rtl/               # Synthesizable System Verilog / Verilog Modules
│   ├── clk_en.v         # Synchronous clock tick distribution prescaler
│   ├── debounce_sync.v  # Double-latch input isolation architecture
│   ├── time_core.v      # Cascade modulo counter processing engine
│   ├── alarm_fsm.v      # Comparator management and time shifting unit
│   ├── buzzer.v         # Audio PWM generation configuration block
│   ├── seg_mux.v        # Dynamic multiplexed character look-up map
│   ├── ui_fsm.v         # Central user operational finite state machine
│   └── top.v            # Global structural netlist routing module
├── tb/                # Testbench suites for functional verification
│   └── clock_tb.v       # Self-checking behavioral simulation wrapper
├── constraints/       # Physical target device design constraint definitions
│   └── physical_pins.xdc # Physical pin assignments for hardware deployment
├── simulation/        # Simulator tool work directories and local run configurations
├── waveforms/         # Exported behavioral signal timing trace logs (.vcd / .wcfg)
├── reports/           # Post-synthesis resource and system timing summary documents
└── docs/              # Specifications, state matrices, and submission documentation

```
---
---
## 🚀 How to Execute & Simulate the Architecture

### Method 1: Cloud-Based Simulation (Via EDA Playground)
1. Open EDA Playground (https://edaplayground.com).
2. Configure Settings Panel parameters to: Language: SystemVerilog/Verilog, Simulator: Icarus Verilog, Check Open EPWave after run.
3. Concatenate and append all source files from rtl/ into the primary Design text window.
4. Copy the verification source block from tb/clock_tb.v into the Testbench panel interface.
5. Click Run in the upper toolbar to execute code execution parameters and access data waveform charts.

### Method 2: Standard Workstation Flow (Via Xilinx Vivado Environment)
1. Launch Vivado and create a new RTL Project.
2. Add all core functional blocks from the rtl/ directory into Design Sources.
3. Import the tb/clock_tb.v wrapper to populate the Simulation Sources structure tree.
4. Reference constraints/physical_pins.xdc to register the hardware layout assignments.
5. In the Flow Navigator, click Run Simulation -> Run Behavioral Simulation to execute verification.

---

## 📉 Simulation Waveform Analysis Data
During the verification pass, verify the design meets the following specific timing conditions:
* **tick_1hz Generation:** Ensure the internal counter asserts its register pulse exactly every 50,000,000 clock iterations under absolute operational parameters.
* **Cascade Modulo Tracking Transition:** At the temporal boundary XX:59:59, check that the next global clock pulse wraps the system values back to zero while incrementing structural hour variables.
* **Identical State Matching Assertion:** When system time counters match the data registered within the alarm latches, verify that buzzer activates an audio PWM waveform on the next clock cycle.

---

## 📊 Synthesis Resource Utilization Summary
* **Cell Mapping Blocks:** Pure standard gate cells; zero structural latches are inferred during synthesis (preventing combinational feedback loops).
* **Clock Routing Efficiency:** All internal storage arrays route to the primary global distribution lines (BUFG), which avoids phase skew across register boundaries.
* **Area footprint:** Highly optimized logic footprint utilizing minimal LUT slices, making it suitable for compact integration profiles in modern embedded SoC applications.