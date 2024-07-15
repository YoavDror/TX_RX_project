`timescale 1ns/1ns

module TX (
    output wire tx_data,
    output wire tx_vld,
    output wire tx_finish,
    input wire clk,
    input wire clr,
    input wire rx_ready
);

    wire read, inc, load, shr;  // Internal wires for state machine signals and shift register control
    wire [1:0] adr;             // Address wire for ROM memory
    wire [7:0] data;            // Data wire from ROM memory

    // Instantiate state machine module (SM_TX)
    SM_TX state_machin_TX (
        .read(read),         // Signal to allow the memory to output the data
        .inc(inc),           // Signal to increment to the next memory cell
        .load(load),         // Signal to load data into the shift register
        .shift(shr),         // Signal to shift the data in the shift register
        .tx_vld(tx_vld),     // Signal indicating valid data from TX
        .tx_finish(tx_finish), // Signal indicating completion of data transfer
        .clk(clk),           // Clock input
        .clr(clr),           // Asynchronous clear input
        .rx_ready(rx_ready), // Signal indicating RX is ready to receive data
        .adr(adr)            // Address input for ROM memory
    );

    // Instantiate ROM module (ROM)
    ROM memory_TX (
        .addr(adr),  // Address input for ROM memory
        .read(read), // Signal to allow the memory to output the data
        .clk(clk),   // Clock input
        .q(data)     // Data output from ROM memory
    );

    // Instantiate shift register module (shift_reg)
    shift_reg shift_reg_TX (
        .clk(clk),       // Clock input
        .clr(clr),       // Asynchronous clear input
        .load(load),     // Signal to load data into the shift register
        .shift(shr),     // Signal to shift the data in the shift register
        .Data(data),     // Data input from ROM memory
        .tx_data(tx_data) // Data output for transmission
    );

    // Instantiate address register module (address_reg)
    address_reg address_reg_TX (
        .clk(clk),   // Clock input
        .clr(clr),   // Asynchronous clear input
        .inc(inc),   // Signal to increment to the next memory cell
        .adrs(adr)   // Address output for ROM memory
    );

endmodule
