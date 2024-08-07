module ALUControl(
    input [2:0] Instruction, // funct3
    input [2:0] ALUOp,
    output [3:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            3'b000: ALUControl = 4'b0010; // lb, sb
            3'b001: ALUControl = 4'b0110; // bne
            3'b010: case (Instruction) // add, and, sll
                3'b000: ALUControl = 4'b0010; // add
                3'b001: ALUControl = 4'b0000; // and
                3'b111: ALUControl = 4'b1000; // sll
                default: ALUControl = 4'b0000;
            endcase
            3'b011: ALUControl = 4'b0001; // ori
            default: ALUControl = 4'b0000;
        endcase
    end

endmodule