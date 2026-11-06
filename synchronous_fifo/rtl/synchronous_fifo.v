
`timescale 1ns/1ps

module synchronous_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8,
    parameter ADDR_WIDTH = 3,
    parameter COUNT_WIDTH = 4
)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,

    output reg [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty,
    output reg [COUNT_WIDTH-1:0] count
);

    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    reg [ADDR_WIDTH-1:0] write_ptr;
    reg [ADDR_WIDTH-1:0] read_ptr;

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    always @(posedge clk) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr  <= 0;
            count     <= 0;
            data_out  <= 0;
        end
        else begin

            // Write operation
            if (wr_en && !full) begin
                memory[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1'b1;
            end

            // Read operation
            if (rd_en && !empty) begin
                data_out <= memory[read_ptr];
                read_ptr <= read_ptr + 1'b1;
            end

            // Occupancy counter
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end

endmodule
