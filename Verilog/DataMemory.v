module DataMemory (
    input wire MemWrite, MemRead,
    input wire [31:0] address,
    input wire [31:0] writeData,
    output reg [31:0] readData
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