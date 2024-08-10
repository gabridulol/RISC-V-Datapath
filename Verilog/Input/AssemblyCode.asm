bne x0, x0, 0
lb x1, 0(x0)
add x2, x1, x1
and x3, x1, x1
ori x4, x1, 32
sll x5, x1, x1
add x6, x3, x2
add x7, x5, x4
add x8, x7, x6
lb x8, 1(x0)