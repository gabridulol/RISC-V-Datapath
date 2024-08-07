module Mux (
    input wire Control,
    input wire [31:0] in0,
    input wire [31:0] in1,  
    output reg [31:0] out
);

    always @(*) begin
        if (Control) begin
            out = in1;
        end else begin
            out = in0;
        end
    end

endmodule
