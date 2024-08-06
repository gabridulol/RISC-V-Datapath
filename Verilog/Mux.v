module Mux (
    input [31:0] in0,  
    input [31:0] in1,
    input control,       
    output reg [31:0] out 
);

    always @(*) begin
        if (control) begin
            out = in1;
        end else begin
            out = in0;
        end
    end
endmodule
