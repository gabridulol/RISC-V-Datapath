`timescale 1ns/100ps

module Datapath_Testbench;
    reg clk, reset;

    Datapath datapath(clk, reset);

    initial begin
        $readmemb("Verilog/Input/DataMemory.mem", datapath.datamemory.memory);
        $readmemb("Verilog/Input/InstructionMemory.mem", datapath.instructionmemory.memory);
        $readmemb("Verilog/Input/Registers.mem", datapath.registers.registers);

        $display("Program Counter = %2d", datapath.pc.PCOut);
        $display("Instruction = %h", datapath.instructionmemory.instruction);
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
    end

    always @(datapath.instructionmemory.instruction) begin
        $display("Program Counter = %2d", datapath.pc.PCOut);
        $display("Instruction = %h", datapath.instructionmemory.instruction);
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register [%2d] = %d", i, datapath.registers.registers[i]);
        end
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

    wire [31:0] PCOut;
    wire [31:0] instruction;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [2:0] ALUOp;
    wire [31:0] readData1, readData2;
    wire [31:0] immediate;
    wire [3:0] ALUControl;
    wire [31:0] MUXOut0, MUXOut1, MUXOut2;
    wire [31:0] ALUResult;
    wire zero;
    wire [31:0] readData;
    wire [31:0] addout0, addout1;

    Add add0(PCOut, 4, addout0);
    Add add1(PCOut, immediate, addout1);
    ALU alu(readData1, MUXOut0, ALUControl, ALUResult, zero);
    ALUControl alucontrol(instruction[14:12], ALUOp, ALUControl);
    Control control(instruction[6:0], Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    DataMemory datamemory(MemWrite, MemRead, ALUResult, readData2, readData);
    ImmGen immgen(instruction, immediate);
    InstructionMemory instructionmemory(PCOut, instruction);
    Mux mux0(ALUSrc, readData2, immediate, MUXOut0);
    Mux mux1(addout1, addout0, Branch & zero, MUXOut1);
    Mux mux2(ALUResult, readData, MemtoReg, MUXOut2);
    PC pc(clk, reset, MUXOut1, PCOut);
    Registers registers(RegWrite, instruction[19:15], instruction[24:20], instruction[11:7], MUXOut2, readData1, readData2);

endmodule