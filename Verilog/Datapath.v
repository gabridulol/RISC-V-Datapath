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
        $display("\n\n");

        for (integer i = 0; i < 32; i = i + 1) begin
            $display("InstructionMemory [%2d] = 0x%h", i, datapath.instructionmemory.memory[i]);
        end
        $display("\n\n");

        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register [%2d] = %d", i, datapath.registers.registers[i]);
        end
        $display("\n\n");
    end

    always @(datapath.Instruction === 32'bx) begin
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("Register [%2d] = %d", i, datapath.registers.registers[i]);
            
        end
         for (integer i = 0; i < 218; i = i + 1) begin
             $display("DataMemory [%2d] = %d", i, datapath.datamemory.memory[i]);
            
        end
        $display("\n\n");
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

    wire [31:0] PCIn, PCOut;
    wire [31:0] Instruction;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [2:0] ALUOp;
    wire [31:0] readData1, readData2;
    wire [31:0] Immediate;
    wire [3:0] ALUControl;
    wire [31:0] MUXOut0, MUXOut1, MUXOut2;
    wire [31:0] ALUResult;
    wire zero;
    wire [31:0] readData;
    wire [31:0] addout0, addout1;

    Add add0(PCOut, 32'h4, addout0);
    Add add1(PCOut, Immediate, addout1);
    ALU alu(readData1, MUXOut0, ALUControl, ALUResult, zero);
    ALUControl alucontrol(Instruction[14:12], ALUOp, ALUControl);
    Control control(Instruction[6:0], Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    DataMemory datamemory(MemWrite, MemRead, ALUResult, readData2, readData);
    ImmGen immgen(Instruction, Immediate);
    InstructionMemory instructionmemory(PCOut, Instruction);
    Mux mux0(ALUSrc, readData2, Immediate, MUXOut0);
    Mux mux1(addout1, addout0, Branch & zero, MUXOut1);
    Mux mux2(readData, ALUResult, MemtoReg, MUXOut2);
    PC pc(clk, reset, MUXOut1, PCOut);
    Registers registers(RegWrite, Instruction[19:15], Instruction[24:20], Instruction[11:7], MUXOut2, readData1, readData2);

endmodule