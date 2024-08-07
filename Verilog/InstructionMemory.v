module InstructionMemory (
    input wire [31:0] ReadAddress,
    output reg [31:0] Instruction
);

    reg [31:0] memory [0:31];

    always @(*) begin
        Instruction = memory[ReadAddress / 4];
    end

endmodule

// module InstructionMemory_TB;
//     reg [31:0] ReadAddress;
//     wire [31:0] Instruction;
    
//     InstructionMemory uut (
//         .ReadAddress(ReadAddress),
//         .Instruction(Instruction)
//     );

//     initial begin
//         for (ReadAddress = 0; ReadAddress < 32; ReadAddress = ReadAddress + 4) begin
//             #10;
//             $display("ReadAddress = %d, Instruction = %b", ReadAddress, Instruction);
//         end
//         $finish
//     end

// endmodule