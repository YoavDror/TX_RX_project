`timescale 1ns/1ns

module RX (
    output wire rx_ready,
    output wire rx_finish,
    input wire tx_vld,
    input wire clk,
    input wire clr,
    input wire tx_data
);

    wire write, inc;
    wire [1:0] adr;
    wire [7:0] data, q;

    // Instantiate state machine module
    SM_RX state_machine_RX (
        .clk(clk),
        .clr(clr),
        .Tx_vld(tx_vld),
        .adr(adr),
        .Rx_ready(rx_ready),
        .write(write),
        .inc(inc),
        .Rx_finish(rx_finish)
    );

    // Instantiate RAM module
    RAM memory_RX (
        .addr(adr),
        .data(data),
        .we(write),
        .clk(clk),
        .q(q)
    );

    // Instantiate shift register module
    shift_reg_RX shiftreg_RX (
        .clk(clk),
        .clr(clr),
        .shift(tx_vld),
        .tx_data(tx_data),
        .shr(data)
    );

    // Instantiate address register module
    address_reg address_reg_RX (
        .clk(clk),
        .clr(clr),
        .inc(inc),
        .adrs(adr)
    );

endmodule
