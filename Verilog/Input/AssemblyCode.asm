lb x1, 0(x0)
00000000000000000000000010000011
add x2, x1, x1
00000000000100001000000100110011
add x3, x2, x1
00000000000100010000000110110011
and x4, x3, x31
00000001111100011111001000110011
and x5, x4, x31
00000001111100100111001010110011
sll x6, x5, x1
00000000000100101001001100110011
sll x7, x6, x1
00000000000100110001001110110011
add x7, x5, x3

sb x7, 1(x30)
00000000011111110000000000100011