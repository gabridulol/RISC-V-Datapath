`timescale 1ns/100ps

module Datapath_Testbench;
    reg clk, reset;

    Datapath datapath(clk, reset);

    initial begin
        $readmemb("Verilog/Input/DataMemory.mem", datapath.datamemory.memory);
        $readmemb("Verilog/Input/InstructionMemory.mem", datapath.instructionmemory.memory);
        $readmemb("Verilog/Input/Registers.mem", datapath.registers.registers);

        for (integer i = 0; i < 32; i = i + 1) begin
            $display("DataMemory [%2d] = %d", i, datapath.datamemory.memory[i]);
        end
        $display();
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("InstructionMemory [%2d] = %h", i, datapath.instructionmemory.memory[i]);
        end
        $display();
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register [%2d] = %d", i, datapath.registers.registers[i]);
        end
        $display();
        $display("Program Counter = %2d", datapath.pc.PCOut);
        $display("Instruction = %h", datapath.instructionmemory.instruction);
        $display();
    end

    always @(datapath.instructionmemory.instruction) begin
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("DataMemory [%2d] = %d", i, datapath.datamemory.memory[i]);
        end
        $display();
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register [%2d] = %d", i, datapath.registers.registers[i]);
        end
        $display();
        $display("Program Counter = %2d", datapath.pc.PCOut);
        $display("Instruction = %h", datapath.instructionmemory.instruction);
        $display();
    end

    initial begin
        clk = 0;
        reset = 1;
        #2 reset = 0;
    end

    always #1 clk = ~clk;

endmodule

module Datapath (
    input wire clk, reset
);

    wire [31:0] PC;
    wire [31:0] instruction;
    wire [31:0] immediate;
    wire [31:0] readData1, readData2, readData3;
    wire [31:0] muxout0, muxout1, muxout2;
    wire [31:0] addout0, addout1;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [2:0] ALUOp;
    wire [3:0] ALUControl;
    wire [31:0] ALUResult;
    wire [6:0] hex0, hex1;
    wire zero;
    
    Add add0(PC, 4, addout0);
    Add add1(PC, immediate, addout1);
    ALU alu(readData1, muxout0, ALUControl, ALUResult, zero);
    ALUControl alucontrol(instruction[14:12], ALUOp, ALUControl);
    Control control(instruction[6:0], Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    DataMemory datamemory(MemWrite, MemRead, ALUResult, readData2, readData3);
    Display display(PC, hex0, hex1);
    ImmGen immgen(instruction, immediate);
    InstructionMemory instructionmemory(PC, instruction);
    Mux mux0(ALUSrc, readData2, immediate, muxout0);
    Mux mux1(Branch & zero, addout0, addout1, muxout1);
    Mux mux2(MemtoReg, ALUResult, readData3, muxout2);
    PC pc(clk, reset, muxout1, PC);
    Registers registers(RegWrite, instruction[19:15], instruction[24:20], instruction[11:7], muxout2, readData1, readData2);

endmodule