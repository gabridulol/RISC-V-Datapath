module ALU (
    input  [31:0] a,    
    input  [31:0] b,     
    input  [2:0] ALUOp, 
    output reg [31:0] ALUResult,
    output reg Zero
);

<<<<<<< HEAD
 localparam [2:0] ADD  = 3'b000, 
                     SUB  = 3'b000, 
                     AND  = 3'b000, 
                     OR   = 3'b000, 
                     XOR  = 3'b000, 
                     SLL  = 3'b000, 
                     ORI  = 3'b000, 
                     BNE  = 3'b000;
=======
    localparam [3:0] LB  = 4'b0010,
                     SB  = 4'b0010,
                     ADD  = 4'b0010, 
                     AND  = 4'b0000,  
                     ORI  = 4'b0001,
                     SLL  = 4'b1000,
                     BNE  = 4'b0110; 

>>>>>>> b4ff5c9 (big big)
    always @(*) begin
        case (ALUOp)
            LB: ALUResult = a + b;
            SB: ALUResult = a + b;
            ADD: ALUResult = a + b;
            AND: ALUResult = a & b;
            ORI: ALUResult = a | b;
            SLL: ALUResult = a << b; 
            BNE: ALUResult = (a != b) ? 1 : 0; 
            default: ALUResult = 32'b0;   
        endcase

        ALUResult == 32'b0 ? Zero = 1'b1 : Zero = 1'b0;
    end

endmodule