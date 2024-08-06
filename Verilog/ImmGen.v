module immGen(
    input [31:0] inst, 
    output [31:0] imm
);

localparam [6:0] TYPE_I = 7'b0010011, /
                     TYPE_S = 7'b0100011, 
                     TYPE_B = 7'b1100011;


lways @(*) begin
        case (instr[6:0])
            TYPE_I: immOut = {{20{instr[31]}}, instr[31:20]}; 
            TYPE_S: immOut = {{20{instr[31]}}, instr[31:25], instr[11:7]}; 
            TYPE_B: immOut = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
            default: immOut = 32'b0; 
        endcase
    end
endmodule