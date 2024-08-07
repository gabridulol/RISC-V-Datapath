module Registers (
    input wire RegWrite,
    input wire [4:0] readReg1, readReg2,
    input wire [4:0] writeReg,
    input wire [31:0] writeData,
    output reg [31:0] readData1, readData2
);

    reg [31:0] registers [0:31];

    initial begin
        $readmemb("Verilog/Input/Registers.mem", registers);
    end

    always @(readReg1, registers[readReg1]) begin
        readData1 <= registers[readReg1];
    end

    always @(readReg2, registers[readReg2]) begin
        readData2 <= registers[readReg2];
    end

    always @(*) begin
        if (RegWrite) begin
            registers[writeReg] <= writeData;
        end
    end

endmodule