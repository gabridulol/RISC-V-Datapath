all:
	iverilog -o outdp Verilog/

run:
	vvp outdp