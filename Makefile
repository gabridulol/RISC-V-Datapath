all:
	iverilog -o outdp Verilog/Add.v Verilog/ALU.v Verilog/ALUControl.v Verilog/Control.v Verilog/DataMemory.v Verilog/Datapath.v Verilog/ImmGen.v Verilog/InstructionMemory.v Verilog/Mux.v Verilog/PC.v Verilog/Registers.v
	vvp outdp