module ALU (
    input  [31:0] a,    
    input  [31:0] b,     
    input  [2:0]  aluOp, 
    output reg [31:0] result, 
);
    always @(*) begin
        case (aluOp)
            ADD: result = a + b;
            SUB: result = a - b;
            AND: result = a & b;
            OR:  result = a | b;
            XOR: result = a ^ b;
            SLL: result = a << b[4:0]; 
            default: result = 32'b0;   
        endcase

    end
endmodule