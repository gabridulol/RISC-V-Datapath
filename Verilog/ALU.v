module ALU (
    input  [31:0] a,    
    input  [31:0] b,     
    input  [2:0]  aluOp, 
    output reg [31:0] result,
    output reg zero  
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

        if (result == 32'b0)
            zero = 1'b1;
        else
            zero = 1'b0;

    end
endmodule