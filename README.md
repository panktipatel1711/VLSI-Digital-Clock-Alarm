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