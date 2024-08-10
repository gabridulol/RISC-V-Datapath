module ALU (
    input wire [31:0] a,  
    input wire [31:0] b,     
    input wire [3:0] ALUControl, 
    output reg [31:0] ALUResult,
    output reg zero
);

    localparam [3:0] LB  = 4'b0010,
                     SB  = 4'b0010,
                     ADD  = 4'b0010, 
                     AND  = 4'b0000,  
                     ORI  = 4'b0001,
                     SLL  = 4'b1000,
                     BNE  = 4'b0110; 

    always @(*) begin
        case (ALUControl) 
            LB: ALUResult = a + b;
            SB: ALUResult = a + b;
            ADD: ALUResult = a + b;
            AND: ALUResult = a & b;
            ORI: ALUResult = a | b;
            SLL: ALUResult = a << b; 
            BNE: ALUResult = (a != b) ? 0 : 1; 
            default: ALUResult = 32'b0;   
        endcase
        zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;
    end

endmodule