module ALU (
    input wire [31:0] a,  
    input wire [31:0] b,     
    input wire [2:0] ALUOp, 
    output reg [31:0] ALUResult,
    output reg Zero
);

    localparam [3:0] LB  = 4'b0010,
                     SB  = 4'b0010,
                     ADD  = 4'b0010, 
                     AND  = 4'b0000,  
                     ORI  = 4'b0001,
                     SLL  = 4'b1000,
                     BNE  = 4'b0110; 

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

        Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;
    end

endmodule