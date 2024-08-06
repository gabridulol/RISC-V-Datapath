module ALU (
    input  [31:0] a,    
    input  [31:0] b,     
    input  [2:0]  aluOp, 
    output reg [31:0] result,
    output reg zero  
);

 localparam [2:0] ADD  = 3'b000, 
                     SUB  = 3'b000, 
                     AND  = 3'b000, 
                     OR   = 3'b000, 
                     XOR  = 3'b000, 
                     SLL  = 3'b000, 
                     ORI  = 3'b000, 
                     BNE  = 3'b000; 

    always @(*) begin
        case (aluOp)
            ADD: result = a + b;
            AND: result = a & b;
            ORI:  result = a | b;
            SW: result = a + b;
            lw: result = a + b;
            BNE: result = (a != b) ? 1 : 0; 
            SLL: result = a << b[4:0]; 
            default: result = 32'b0;   
        endcase

        if (result == 32'b0)
            zero = 1'b1;
        else
            zero = 1'b0;

    end
endmodule