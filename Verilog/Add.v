module pcAdd(
    input  [31:0] pc,   
    output [31:0] sum
);

    assign sum = pc + 32'd4;

endmodule

module immAdd(
    input  [31:0] rs1, 
    input  [31:0] imm, 
    output [31:0] sum 
);

    assign sum = rs1 + imm;

endmodule