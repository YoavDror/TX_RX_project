`timescale 1ns/1ns

module shift_reg_RX (
    input wire clk,
    input wire clr,
    input wire shift,
    input wire tx_data,
    output reg [7:0] shr
);

    always @(posedge clk or negedge clr) begin
        if (~clr)  // Asynchronous clear
            shr <= 8'b0;  // Reset shift register to 0 when clr is low
        else if (shift)  // Shift right operation
            shr <= #1 {tx_data, shr[7:1]};  // Shift shr right by one bit, insert tx_data at LSB
    end

endmodule
