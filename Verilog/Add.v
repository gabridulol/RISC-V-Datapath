module Add (
    input wire [31:0] a, b
    output reg [31:0] sum
);

  assign sum = a + b;

endmodule