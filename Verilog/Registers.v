module Registers (
    input clk, reset,
    input RegWrite,
    input [4:0] readReg1, readReg2
    input [4:0] writeReg
    input [31:0] writeData
    output [31:0] readData1, readData2
);

    reg [31:0] registers [0:31];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (integer i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;
            end
        end else if (RegWrite) begin
            registers[writeReg] <= writeData;
        end
    end

    always @(readReg1, registers[readReg1]) begin
        readData1 <= registers[readReg1];
    end

    always @(readReg2, registers[readReg2]) begin
        readData2 <= registers[readReg2];
    end

endmodule