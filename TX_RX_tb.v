`timescale 1ns/1ns

module TX_RX_tb ();

    wire tx_finish_tb;
    wire rx_finish_tb;
    reg clk_tb;
    reg clr_tb;

    // Instantiate the device under test (DUT)
    TX_RX DUT (
        .RX_finish(rx_finish_tb),
        .TX_finish(tx_finish_tb),
        .clk(clk_tb),
        .clr(clr_tb)
    );

    integer fd; // File descriptor for mem_out
    integer i;

    // Clock generation
    initial begin
        clk_tb = 0;
        clr_tb = 0;
    end

    always #5 clk_tb = ~clk_tb; // Toggle clock every 5 time units

    // Reset sequence
    initial begin
        clk_tb = 0;
        clr_tb = 0;

        // Resetting module
        repeat (2) @(posedge clk_tb); // Wait for 2 clock cycles
        clr_tb = 1; // Assert reset
    end

    // Simulation monitor
    always @(posedge clk_tb) begin
        // Display RX ready signal
        if (DUT.RX_1.rx_ready) begin
            $display("time:%0t   rx_ready:%b", $time, DUT.RX_1.rx_ready);
        end

        // Display TX valid signal and data
        if (DUT.TX_1.tx_vld) begin
            $display("time:%0t   tx_vld:%b   tx_data:%h", $time, DUT.TX_1.tx_vld, DUT.TX_1.tx_data);
        end

        // Display RAM address when increment occurs
        if (DUT.RX_1.inc) begin
            $display("time:%0t              Ram_Address:%h", $time, DUT.RX_1.adr);
        end

        // Check for RX finish and write memory contents to file
        if (DUT.RX_1.rx_finish) begin
            $display("time:%0t              Ram_Address:%h", $time, DUT.RX_1.adr);
            $display("time:%0t              Rx_finish:%b", $time, DUT.RX_1.rx_finish);
            
            // Open file for writing memory contents
            fd = $fopen("mem_out.list", "w");
            for (i = 0; i < 4; i = i + 1) begin
                $fdisplay(fd, "%h", DUT.RX_1.memory_RX.ram[i]); // Print each memory word to file
            end
            #20;
            $fclose(fd); // Close file after 20 time units
            
            $finish; // End simulation
        end
    end

endmodule
