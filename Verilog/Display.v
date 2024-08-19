module Display (
    input wire [31:0] PC,
    output reg [6:0] hex0,
    output reg [6:0] hex1
);

    function [6:0] to_7seg;
        input [3:0] value;
        case(value)
            4'd0: to_7seg = 7'b1000000; // 0
            4'd1: to_7seg = 7'b1111001; // 1
            4'd2: to_7seg = 7'b0100100; // 2
            4'd3: to_7seg = 7'b0110000; // 3
            4'd4: to_7seg = 7'b0011001; // 4
            4'd5: to_7seg = 7'b0010010; // 5
            4'd6: to_7seg = 7'b0000010; // 6
            4'd7: to_7seg = 7'b1111000; // 7
            4'd8: to_7seg = 7'b0000000; // 8
            4'd9: to_7seg = 7'b0010000; // 9
            default: to_7seg = 7'b1111111; // Error
        endcase
    endfunction

    wire [3:0] units_digit = (PC / 4) % 10;
    wire [3:0] tens_digit = (PC / 4) / 10;

    always @(PC) begin
        hex0 = to_7seg(units_digit);
        hex1 = to_7seg(tens_digit);
    end

endmodule