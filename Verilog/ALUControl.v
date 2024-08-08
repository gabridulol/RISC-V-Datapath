module ALUControl(
    input wire [2:0] instruction,
    input wire [2:0] ALUOp,
    output reg [3:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            3'b000: ALUControl = 4'b0010; // lb, sb
            3'b001: ALUControl = 4'b0110; // bne
            3'b010: case (instruction) // add, and, sll
                3'b000: ALUControl = 4'b0010; // add
                3'b001: ALUControl = 4'b1000; // sll
                3'b111: ALUControl = 4'b0000; // and
                default: ALUControl = 4'b0000;
            endcase
            3'b011: ALUControl = 4'b0001; // ori
            default: ALUControl = 4'b0000;
        endcase
    end

endmodule