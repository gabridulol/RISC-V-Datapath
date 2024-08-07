module ImmGen(
    input  wire [31:0] Instruction,
    output reg [31:0] Immediate
);

    localparam [6:0] TYPE_I  = 7'b0000011,
                     TYPE_Ii = 7'b0010011,
                     TYPE_S  = 7'b0100011, 
                     TYPE_SB = 7'b1100111;

    always @(*) begin
        case (Instruction[6:0])
            TYPE_I: Immediate = {{20{Instruction[31]}}, Instruction[31:20]};
            TYPE_Ii: Immediate = {{20{Instruction[31]}}, Instruction[31:20]};
            TYPE_S: Immediate = {{20{Instruction[31]}}, Instruction[31:25], Instruction[11:7]};
            TYPE_SB: Immediate = {{19{Instruction[31]}}, Instruction[31], Instruction[7], Instruction[30:25], Instruction[11:8], 1'b0};
            default: Immediate = 32'b0; 
        endcase
    end

endmodule

// module ImmGen_TP;
//     reg [31:0] Instruction;
//     wire [31:0] Immediate;

//     ImmGen uut (
//         .Instruction(Instruction),
//         .Immediate(Immediate)
//     );

//     initial begin
//         Instruction = 32'b00000010010100110000010000100011;
//         #10;
//         $display("Instruction = %b, Immediate = %b [%d]", Instruction, Immediate, Immediate);
//         $finish;
//     end

// endmodule