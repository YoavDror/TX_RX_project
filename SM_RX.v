`timescale 1ns/1ns

module SM_RX (
    input wire clk,
    input wire clr,
    input wire Tx_vld,
    input wire [1:0] adr,
    output wire Rx_ready,
    output wire write,
    output wire inc,
    output wire Rx_finish
);

    reg [3:0] state;  // State register
    reg [3:0] out;    // Output register to control Rx_ready, write, inc, Rx_finish

    // Declare states
    parameter wait_tx_vld   = 4'h0;  // Waiting for valid data from Tx
    parameter sh1           = 4'h1;  // Starting inserting data to shift register
    parameter sh2           = 4'h2;  // Shift right (1)
    parameter sh3           = 4'h3;  // Shift right (2)
    parameter sh4           = 4'h4;  // Shift right (3)
    parameter sh5           = 4'h5;  // Shift right (4)
    parameter sh6           = 4'h6;  // Shift right (5)
    parameter sh7           = 4'h7;  // Shift right (6)
    parameter sh8           = 4'h8;  // Shift right (7)
    parameter write_mem     = 4'h9;  // Inserting data to RAM memory
    parameter inc_adrs      = 4'hA;  // Next memory cell in RAM memory
    parameter finish_rx     = 4'hB;  // Received all the data

    // Output assignment based on current state
    assign {Rx_ready, write, inc, Rx_finish} = out;

    // State transition block
    always @(posedge clk or negedge clr) begin
        if (~clr) 
            state <= wait_tx_vld;  // Initial state after reset
        else begin
            case (state)
                wait_tx_vld:    state <= (Tx_vld == 1) ? sh1 : wait_tx_vld;  // Wait for valid data from Tx
                sh1:            state <= sh2;
                sh2:            state <= sh3;
                sh3:            state <= sh4;
                sh4:            state <= sh5;
                sh5:            state <= sh6;
                sh6:            state <= sh7;
                sh7:            state <= sh8;
                sh8:            state <= write_mem;
                write_mem:      state <= (adr == 2'b11) ? finish_rx : inc_adrs;  // Check if last memory cell, then finish_rx else inc_adrs
                inc_adrs:       state <= wait_tx_vld;  // Go back to waiting for new data
            endcase
        end
    end

    // Output logic for Rx_ready, write, inc, Rx_finish based on state
    always @* begin
        case (state)
            wait_tx_vld:    out = 4'b1000;  // Rx_ready = 1, write = 0, inc = 0, Rx_finish = 0
            sh1, sh2, sh3, sh4, sh5, sh6, sh7, sh8:  out = 4'b0000;  // All outputs are 0 during shifting
            write_mem:      out = 4'b0100;  // Rx_ready = 0, write = 1, inc = 0, Rx_finish = 0
            inc_adrs:       out = 4'b0010;  // Rx_ready = 0, write = 0, inc = 1, Rx_finish = 0
            finish_rx:      out = 4'b0001;  // Rx_ready = 0, write = 0, inc = 0, Rx_finish = 1
            default:        out = 4'b0000;  // Default state, all outputs are 0
        endcase
    end

endmodule
