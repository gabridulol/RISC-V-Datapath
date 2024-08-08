module ImmGen(
    input  wire [31:0] instruction,
    output reg [31:0] immediate
);

    localparam [6:0] TYPE_I  = 7'b0000011,
                     TYPE_Ii = 7'b0010011,
                     TYPE_S  = 7'b0100011, 
                     TYPE_SB = 7'b1100111;

    always @(*) begin
        case (instruction[6:0])
            TYPE_I: immediate = {{20{instruction[31]}}, instruction[31:20]};
            TYPE_Ii: immediate = {{20{instruction[31]}}, instruction[31:20]};
            TYPE_S: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            TYPE_SB: immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            default: immediate = 32'b0; 
        endcase
    end

endmodule