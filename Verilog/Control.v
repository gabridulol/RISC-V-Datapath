module Control (
    input wire [6:0] Instruction,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [2:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);

    always @(*) begin
        case (Instruction)
            7'b0000011: begin // lb
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1;
                ALUOp = 3'b000;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            7'b1100011: begin // sb
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b000;
                MemWrite = 1;
                ALUSrc = 0;
                RegWrite = 0;
            end
            7'b0110011: begin // add, and, sll
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b010;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            7'b1100011: begin // ori
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b011;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            7'b1100111: begin // bne
                Branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b001;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 0;
            end
            default: begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 0;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 0;
            end
        endcase
    end

endmodule

