
`timescale 1ns/1ps

module synchronous_fifo_tb;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [7:0] data_in;

    wire [7:0] data_out;
    wire full;
    wire empty;
    wire [3:0] count;

    integer i;

    synchronous_fifo DUT (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .count(count)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Write task
    task fifo_write;
        input [7:0] value;
        begin
            @(negedge clk);
            wr_en = 1;
            rd_en = 0;
            data_in = value;

            @(posedge clk);
            #1;

            wr_en = 0;

            $display("WRITE: Data = %h | Count = %d", value, count);
        end
    endtask

    // Read task
    task fifo_read;
        input [7:0] expected_value;
        begin
            @(negedge clk);
            wr_en = 0;
            rd_en = 1;

            @(posedge clk);
            #1;

            if (data_out !== expected_value) begin
                $display("ERROR: Expected %h, Got %h",
                         expected_value, data_out);
                $fatal;
            end
            else begin
                $display("READ PASS: Expected = %h | Actual = %h | Count = %d",
                         expected_value, data_out, count);
            end

            rd_en = 0;
        end
    endtask

    initial begin

        $dumpfile("sim/fifo_waveform.vcd");
        $dumpvars(0, synchronous_fifo_tb);

        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Reset
        repeat (2) @(posedge clk);
        #1;
        rst = 0;

        if (empty !== 1 || count !== 0)
            $fatal(1, "RESET TEST FAILED");

        $display("RESET TEST PASSED");

        // Fill FIFO with 8 values
        for (i = 0; i < 8; i = i + 1)
            fifo_write(i + 8'hA0);

        if (full !== 1)
            $fatal(1, "FULL FLAG TEST FAILED");

        $display("FULL FLAG TEST PASSED");

        // Attempt write while full
        fifo_write(8'hFF);

        if (count !== 8)
            $fatal(1, "OVERFLOW TEST FAILED");

        $display("OVERFLOW PROTECTION TEST PASSED");

        // Read back all 8 values in FIFO order
        for (i = 0; i < 8; i = i + 1)
            fifo_read(i + 8'hA0);

        if (empty !== 1)
            $fatal(1, "EMPTY FLAG TEST FAILED");

        $display("EMPTY FLAG TEST PASSED");

        // Attempt read while empty
        @(negedge clk);
        rd_en = 1;

        @(posedge clk);
        #1;

        rd_en = 0;

        if (count !== 0 || empty !== 1)
            $fatal(1, "UNDERFLOW TEST FAILED");

        $display("UNDERFLOW PROTECTION TEST PASSED");

// Simultaneous read and write test
fifo_write(8'h11);
fifo_write(8'h22);
fifo_write(8'h33);

@(negedge clk);
wr_en = 1;
rd_en = 1;
data_in = 8'h44;

@(posedge clk);
#1;

if (data_out !== 8'h11)
    $fatal(1, "SIMULTANEOUS READ/WRITE DATA TEST FAILED");

if (count !== 3)
    $fatal(1, "SIMULTANEOUS READ/WRITE COUNT TEST FAILED");

$display("SIMULTANEOUS READ/WRITE TEST PASSED");

wr_en = 0;
rd_en = 0;

// Remaining data must preserve FIFO order
fifo_read(8'h22);
fifo_read(8'h33);
fifo_read(8'h44);

        $display("--------------------------------");
        $display("ALL FIFO TESTS PASSED!");
        $display("--------------------------------");

        $finish;
    end

endmodule
