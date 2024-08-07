all:
	iverilog -o outdp Verilog/InstructionMemory.v
	vvp outdp