`timescale 1ns/1ns

module SM_TX (
    input wire clk,
    input wire clr,
    input wire rx_ready,  // RX is ready to receive data
    input wire [1:0] adr, // 2-bit address for 4 addresses
    output wire read,     // Allows the memory to output the data
    output wire inc,      // Next memory cell
    output wire load,     // Loading the data to the shift_reg
    output wire shift,    // Shifting the register read_mem bit right
    output wire tx_vld,   // The data from TX is valid
    output wire tx_finish // Finished transferring the data from all the memory
);

    reg [3:0] state;  // State register
    reg [5:0] out;    // Output register to control read, load, shift, tx_vld, inc, tx_finish

    // Declare states
    parameter wait_rx_rdy  = 4'h0;  // Waiting for RX to be ready to get data
    parameter read_mem     = 4'h1;  // Reading data from ROM memory
    parameter load_to_shr  = 4'h2;  // Loading the data from ROM memory to shift register
    parameter shr1         = 4'h3;  // Shift right (1)
    parameter shr2         = 4'h4;  // Shift right (2)
    parameter shr3         = 4'h5;  // Shift right (3)
    parameter shr4         = 4'h6;  // Shift right (4)
    parameter shr5         = 4'h7;  // Shift right (5)
    parameter shr6         = 4'h8;  // Shift right (6)
    parameter shr7         = 4'h9;  // Shift right (7)
    parameter inc_adrs     = 4'hA;  // Next memory cell in RAM memory
    parameter finish_tx    = 4'hB;  // Transmitted all the data

    // Output assignment based on current state
    assign {read, load, shift, tx_vld, inc, tx_finish} = out;

    // State transition block
    always @(posedge clk or negedge clr) begin
        if (~clr) 
            state <= wait_rx_rdy;  // Initial state after reset
        else begin
            case (state)
                wait_rx_rdy:    state <= (rx_ready == 1) ? read_mem : wait_rx_rdy;  // Waiting for RX to be ready
                read_mem:       state <= load_to_shr;
                load_to_shr:    state <= shr1;
                shr1:           state <= shr2;
                shr2:           state <= shr3;
                shr3:           state <= shr4;
                shr4:           state <= shr5;
                shr5:           state <= shr6;
                shr6:           state <= shr7;
                shr7:           state <= inc_adrs;
                inc_adrs:       state <= (adr == 2'b11) ? finish_tx : wait_rx_rdy;  // Check if last memory cell, then finish_tx else inc_adrs
            endcase
        end
    end

    // Output logic for read, load, shift, tx_vld, inc, tx_finish based on state
    always @* begin
        case (state)
            wait_rx_rdy:    out = 6'b000000;  // read = 0, load = 0, shift = 0, tx_vld = 0, inc = 0, tx_finish = 0
            read_mem:       out = 6'b100000;  // read = 1, load = 0, shift = 0, tx_vld = 0, inc = 0, tx_finish = 0
            load_to_shr:    out = 6'b010000;  // read = 0, load = 1, shift = 0, tx_vld = 0, inc = 0, tx_finish = 0
            shr1, shr2, shr3, shr4, shr5, shr6, shr7:  out = 6'b001100;  // read = 0, load = 0, shift = 1, tx_vld = 1, inc = 0, tx_finish = 0
            inc_adrs:       out = 6'b000110;  // read = 0, load = 0, shift = 0, tx_vld = 1, inc = 1, tx_finish = 0
            finish_tx:      out = 6'b000001;  // read = 0, load = 0, shift = 0, tx_vld = 0, inc = 0, tx_finish = 1
            default:        out = 6'b000000;  // Default state, all outputs are 0
        endcase
    end

endmodule
