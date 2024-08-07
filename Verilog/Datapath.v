module Datapath_Testbench;
    reg clk, reset;

    Datapath datapath(clk, reset);

    initial begin
        // Load memory files
        $readmemb("Verilog/Input/DataMemory.mem", datapath.datamemory.memory);
        $readmemb("Verilog/Input/InstructionMemory.mem", datapath.instructionmemory.memory);
        $readmemb("Verilog/Input/Registers.mem", datapath.registers.registers);
        
        // Print memory contents
        $display("Data Memory Contents:");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("datamemory[%0d] = %h", i, datapath.datamemory.memory[i]);
        end

        $display("Instruction Memory Contents:");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("instructionmemory[%0d] = %h", i, datapath.instructionmemory.memory[i]);
        end

        $display("Registers Contents:");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("registers[%0d] = %h", i, datapath.registers.registers[i]);
        end
    end

    initial begin
        // Initial conditions
        clk = 0;
        reset = 1;
        #5 reset = 0;
    end

    always #5 clk = ~clk; // Clock generation with a period of 10 units

endmodule

module Datapath (
    input wire clk, reset
);

    wire [31:0] PCIn, PCOut;
    wire [31:0] Instruction;
    wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
    wire [2:0] ALUOp;
    wire [31:0] readData1, readData2; // MUX Result DataMemory
    wire [31:0] Immediate;
    wire [3:0] ALUControl;
    wire [31:0] MUXOut0, MUXOut1, MUXOut2;
    wire [31:0] ALUResult;
    wire zero;
    wire [31:0] readData;
    wire [31:0] addout0, addout1;

    Add add0(PCOut, 00000000000000000000000000000100, addout0);
    Add add1(PCOut, Immediate, addout1);
    ALU alu(readData1, MUXOut0, ALUOp, ALUResult, zero);
    ALUControl alucontrol(Instruction[14:12], ALUOp, ALUControl);
    Control control(Instruction[6:0], Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    DataMemory datamemory(MemWrite, MemRead, ALUResult, readData2, readData);
    ImmGen immgen(Instruction, Immediate);
    InstructionMemory instructionmemory(PCOut, Instruction);
    Mux mux0(ALUSrc, readData2, Immediate, MUXOut0);
    Mux mux1(addout1, addout0, Branch & zero, MUXOut1);
    Mux mux2(ALUResult, readData, MemtoReg, MUXOut2);
    PC pc(clk, reset, MUXOut1, PCOut);
    Registers registers(RegWrite, Instruction[19:15], Instruction[24:20], Instruction[11:7], MUXOut2, readData1, readData2);

endmodule

// `timescale 1ns/100ps
// module Datapath_tb;
//     reg clk, reset;
//     wire [31:0] PCIn;
//     wire [31:0] PCOut;
//     wire [31:0] Instruction;
//     wire [31:0] Immediate;
//     wire Branch, MemRead, MemtoReg;
//     wire [2:0] ALUOp;
//     wire MemWrite, ALUSrc, RegWrite;
//     wire [4:0] readReg1, readReg2, writeReg;
//     wire [31:0] writeData, readData1, readData2;
//     wire [31:0] muxALU, muxPC, muxWB;
//     wire zero;
//     wire [31:0] ALUResult;
 


//     // Instâncias dos módulos
//     PC uutPC (
//         .clk(clk),
//         .reset(reset),
//         .PCIn(PCIn),
//         .PCOut(PCOut)
//     );

//     InstructionMemory uutInstructionMemory (
//         .ReadAddress(PCOut),
//         .Instruction(Instruction)
//     );

//     Control uutControl (
//         .Instruction(Instruction[6:0]),
//     );

//     AluControl uutAluControl (
//         .Instruction(Instruction)
//     );

//     Registers uutRegisters (
//         .RegWrite(RegWrite),
//         .readReg1(Instruction[19:15]),
//         .readReg2(Instruction[24:20]),
//         .writeReg(writeReg),
//         .writeData(writeData),
//         .readData1(readData1),
//         .readData2(readData2)
//     );

//     ImmGen uutImmGen (
//         .Instruction(Instruction),
//         .Immediate(Immediate)
//     );

//     Alu uutAlu (
//         .ALUOp(ALUOp),
//         .ALUSrc(ALUSrc),
//         .A(readData1),
//         .B(muxALU),
//         .Result(writeData)
//     );

//     DataMemory uutDataMemory (
//         .MemRead(MemRead),
//         .MemWrite(MemWrite),
//         .Address(ALUResult),
//         .WriteData(readData2),
//         .ReadData(writeData)
//     );

//     Mux uutMuxWB (
//         .A(ALUResult),
//         .B(readData2),
//         .S(MemtoReg),
//         .Y(muxWB)
//     );


//     // Gerador de clock
//     always begin
//         #5 clk = ~clk; // Toggle clock every 5 time units
//     end

//     // Sequência de inicialização e teste
//     initial begin
//         // Inicialização
//         clk = 0;
//         reset = 0;

//         // Aplicar reset
//         reset = 1;
//         #10;
//         reset = 0;

//         // Teste 1
//         #10;
//         PCIn = 32'h00000000;
//         #10;
//         $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

//         // Teste 2
//         #10;
//         PCIn = 32'h00000004;
//         #10;
//         $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

//         // Teste 3
//         #10;
//         PCIn = 32'h00000008;
//         #10;
//         $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

//         // Teste 4
//         #10;
//         PCIn = 32'h0000000C;
//         #10;
//         $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

//         // Teste 5
//         #10;
//         PCIn = 32'h00000010;
//         #10;
//         $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

//         // Teste 6
//         #10;
//         PCIn = 32'h00000014;
//         #10;
//         $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

//         // Teste 7
//         #10;
//         PCIn = 32'h00000018;
//         #10;
//         $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

//         // Teste 8
//         #10;
//         PCIn = 32'h0000001C;
//         #10;
//         $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

//         // Finalização do teste
//         #10;
//         $finish;
//     end

// endmodule