`timescale 1ns/1ns

module shift_reg (
    input wire clk,
    input wire clr,
    input wire load, shift,
    input wire [7:0] Data,
    output reg tx_data
);

    reg [7:0] shr; // Register to hold the data bits

    // Output assignment
    assign tx_data = shr[0];  // Output the LSB of the shift register

    always @(posedge clk or negedge clr) begin
        if (~clr)  // Asynchronous clear
            shr <= 8'b0;  // Reset shift register to 0 when clr is low
        else if (load)  // Load data into the shift register
            shr <= #1 Data;  // Load Data into shr with 1ns delay
        else if (shift)  // Shift right operation
            shr <= #1 {1'b0, shr[7:1]};  // Shift shr right by one bit, fill MSB with 0
    end

endmodule
