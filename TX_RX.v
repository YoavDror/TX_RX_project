`timescale 1ns/1ns

module TX_RX (
    output wire RX_finish,    // Signal indicating RX module has finished receiving data
    output wire TX_finish,    // Signal indicating TX module has finished transmitting data
    input wire clk,           // Clock input
    input wire clr            // Asynchronous clear input
);

    wire TX_data, TX_vld, RX_rdy;  // Internal signals for data, valid signal, and ready signal

    // Instantiate TX module (TX)
    TX TX_1 (
        .tx_data(TX_data),      // Data output for transmission
        .tx_vld(TX_vld),        // Signal indicating valid data from TX
        .tx_finish(TX_finish),  // Signal indicating completion of data transmission
        .clk(clk),              // Clock input
        .clr(clr),              // Asynchronous clear input
        .rx_ready(RX_rdy)       // Signal indicating RX is ready to receive data
    );

    // Instantiate RX module (RX)
    RX RX_1 (
        .rx_ready(RX_rdy),      // Signal indicating RX is ready to receive data
        .rx_finish(RX_finish),  // Signal indicating RX module has finished receiving data
        .tx_vld(TX_vld),        // Signal indicating valid data from TX
        .clk(clk),              // Clock input
        .clr(clr),              // Asynchronous clear input
        .tx_data(TX_data)       // Data input for transmission
    );

endmodule
