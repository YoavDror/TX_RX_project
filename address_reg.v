`timescale 1ns/1ns

module address_reg (
    input clk,               // Clock input
    input clr,               // Clear input
    input inc,               // Increment input
    output reg [1:0] adrs    // 2-bit output register
);

    always @(posedge clk or negedge clr) begin
        if (~clr)               // Asynchronous clear
            adrs <= 0;          // Reset adrs to 0 when clr is low
        else if (inc)           // Increment adrs on positive edge of clk when inc is high
            adrs <= adrs + 1;   // Increment adrs by 1
    end

endmodule
