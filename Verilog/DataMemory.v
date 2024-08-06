module DataMemory (
    input clk, reset
    input MemWrite, MemRead,
    input [31:0] address,
    input [31:0] writeData,
    output [31:0] readData
);

reg [31:0] memory [0:31];

always @(*) begin
    if (MemRead) begin
        readData = memory[address];
    end else if (MemWrite) begin
        memory[address] = writeData;
    end
end

endmodule