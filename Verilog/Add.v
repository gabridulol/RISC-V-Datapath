module Add (
    input wire [31:0] a, b,
    output [31:0] result
);

    assign result = a + b;

endmodule