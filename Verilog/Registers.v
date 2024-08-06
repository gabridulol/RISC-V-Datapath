module Registers (
    input RegWrite,
    input [4:0] readReg1, readReg2
    input [4:0] writeReg
    input [31:0] writeData
    output [31:0] readData1, readData2
);

    reg [31:0] registers [0:31];

    always @(readReg1, registers[readReg1]) begin
        readData1 <= registers[readReg1];
    end

    always @(readReg2, registers[readReg2]) begin
        readData2 <= registers[readReg2];
    end

    always @(*) begin
        if (RegWrite) begin
            readData1 = writeData;
        end
    end

endmodule