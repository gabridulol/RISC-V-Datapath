module InstructionMemory (
    input [31:0] ReadAddress,
    output reg [31:0] Instruction
);

    reg [31:0] memory [0:31];

    initial begin
        $readmemb("Verilog/Input/InstructionMemory.mem", memory);
    end

    always @(*) begin
        Instruction = memory[ReadAddress];
    end

endmodule

module InstructionMemory_TB;
    reg [31:0] ReadAddress;
    wire [31:0] Instruction;
    
    InstructionMemory uut (
        .ReadAddress(ReadAddress),
        .Instruction(Instruction)
    );

    initial begin
        $display("Testing Instruction Memory Read");
        for (ReadAddress = 0; ReadAddress < 32; ReadAddress = ReadAddress + 1) begin
            #10;
            $display("ReadAddress = %d, Instruction = %b", ReadAddress, Instruction);
        end
        $stop;
    end

endmodule
