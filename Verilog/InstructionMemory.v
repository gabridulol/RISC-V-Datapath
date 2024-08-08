module InstructionMemory (
    input wire [31:0] readAddress,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:31];

    always @(*) begin
        instruction = memory[readAddress / 4];
    end

endmodule