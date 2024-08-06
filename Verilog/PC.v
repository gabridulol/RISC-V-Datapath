module ProgramCounter (
    input clk,               
    input reset,             
    input [31:0] pcIn,    
    output reg [31:0] pc     
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pc <= 32'b0;
        end else begin
            pc <= pcIn; 
        end
    end
endmodule
