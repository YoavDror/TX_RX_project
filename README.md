**Verilog Digital Communication System Project Summary**

This Verilog project implements a digital communication system comprising several modules:

1. **TX Module (`TX`)**:
   - Transmits data (`tx_data`) when `tx_vld` (data valid) is active.
   - Controlled by a state machine (`SM_TX`) managing data flow from a ROM (`memory_TX`) to a shift register (`shift_reg_TX`).

2. **RX Module (`RX`)**:
   - Receives data (`tx_data`) when `rx_ready` (ready to receive) is active.
   - Uses a state machine (`SM_RX`) to handle data reception, from shifting (`shift_reg_RX`) to storing in RAM (`memory_RX`).

3. **Memory Module (`RAM`)**:
   - Implements RAM with configurable data width (`DATA_WIDTH`) and address width (`ADDR_WIDTH`).
   - Supports write (`we`) and read (`q`) operations synchronized with the clock (`clk`).

4. **Shift Registers (`shift_reg`)**:
   - Includes modules (`shift_reg_TX` and `shift_reg_RX`) for data shifting operations based on clock signals (`clk`), loading (`load`), and clearing (`clr`).

5. **Address Registers (`address_reg`)**:
   - Manages address generation (`adrs`) for sequential or incremental memory access based on clock signals (`clk`), clear signals (`clr`), and increment signals (`inc`).

6. **State Machines (`SM_TX` and `SM_RX`)**:
   - Control overall operation:
     - TX (`SM_TX`): Manages data transmission states (`wait_tx_vld`, `sh1` to `sh8`, `write_mem`, `inc_adrs`, `finish_tx`).
     - RX (`SM_RX`): Handles data reception states (`wait_rx_rdy`, `sh1` to `sh8`, `write_mem`, `inc_adrs`, `finish_rx`).

7. **Top-Level Module (`TX_RX`)**:
   - Integrates TX and RX modules for bidirectional data transmission.

8. **Testbench (`TX_RX_tb`)**:
   - Provides simulation environment to verify functionality.
   - Monitors readiness (`rx_ready`), data validity (`tx_vld`), memory addresses (`adr`), and completion (`rx_finish`, `tx_finish`).

**Objective:**
- Demonstrate a serial digital communication system design using Verilog HDL.
- Showcase efficient data transmission, reception, memory storage, and control mechanisms.

