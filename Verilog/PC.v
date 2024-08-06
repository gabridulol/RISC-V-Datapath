module PC (
    input clk, reset   
    input [31:0] PCIn,
    output [31:0] PCOut
);
    always @(posedge clk) begin
        if (reset) begin
            PCOut <= 32'b0;
        end else begin
            PCOut <= PCIn; 
        end
    end
endmodule
