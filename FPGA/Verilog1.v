//=======================================================
//  Add
//=======================================================

module Add (
    input wire [31:0] a, b,
    output [31:0] result
);

    assign result = a + b;

endmodule

//=======================================================
//  ALU
//=======================================================

module ALU (
    input wire [31:0] a,  
    input wire [31:0] b,     
    input wire [3:0] ALUControl, 
    output reg [31:0] ALUResult,
    output reg zero
);

    localparam [3:0] LB  = 4'b0010,
                     SB  = 4'b0010,
                     ADD  = 4'b0010, 
                     AND  = 4'b0000,  
                     ORI  = 4'b0001,
                     SLL  = 4'b1000,
                     BNE  = 4'b0110; 

    always @(*) begin
        case (ALUControl) 
            LB: ALUResult = a + b;
            SB: ALUResult = a + b;
            ADD: ALUResult = a + b;
            AND: ALUResult = a & b;
            ORI: ALUResult = a | b;
            SLL: ALUResult = a << b; 
            BNE: ALUResult = (a != b) ? 0 : 1; 
            default: ALUResult = 32'b0;   
        endcase
        zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;
    end

endmodule

//=======================================================
//  ALUControl
//=======================================================

module ALUControl(
    input wire [2:0] instruction,
    input wire [2:0] ALUOp,
    output reg [3:0] ALUControl
);

    always @(*) begin
        case (ALUOp)
            3'b000: ALUControl = 4'b0010; // lb, sb
            3'b001: ALUControl = 4'b0110; // bne
            3'b010: case (instruction) // add, and, sll
                3'b000: ALUControl = 4'b0010; // add
                3'b001: ALUControl = 4'b1000; // sll
                3'b111: ALUControl = 4'b0000; // and
                default: ALUControl = 4'b0000;
            endcase
            3'b011: ALUControl = 4'b0001; // ori
            default: ALUControl = 4'b0000;
        endcase
    end

endmodule

//=======================================================
//  Control
//=======================================================

module Control (
    input wire [6:0] instruction,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg [2:0] ALUOp,
    output reg MemWrite,
    output reg ALUSrc,
    output reg RegWrite
);

    always @(*) begin
        case (instruction)
            7'b0000011: begin // lb
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1;
                ALUOp = 3'b000;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            7'b0100011: begin // sb
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b000;
                MemWrite = 1;
                ALUSrc = 1;
                RegWrite = 0;
            end
            7'b0110011: begin // add, and, sll
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b010;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 1;
            end
            7'b0010011: begin // ori
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b011;
                MemWrite = 0;
                ALUSrc = 1;
                RegWrite = 1;
            end
            7'b1100111: begin // bne
                Branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b001;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 0;
            end
            default: begin
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                ALUOp = 3'b000;
                MemWrite = 0;
                ALUSrc = 0;
                RegWrite = 0;
            end
        endcase
    end

endmodule

//=======================================================
//  DataMemory
//=======================================================

module DataMemory (
    input wire MemWrite, MemRead,
    input wire [31:0] address,
    input wire [31:0] writeData,
    output reg [31:0] readData
);

    reg [31:0] memory [0:31];

    initial begin
        memory[0] = 32'b00000000000000000000000000000100;
    end

    always @(*) begin
        if (MemRead) begin
            readData = memory[address];
        end else if (MemWrite) begin
            memory[address] = writeData;
        end
    end

endmodule

//=======================================================
//  Datapath
//=======================================================

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
    wire [6:0] HEX0, HEX1;
    wire zero;
    
    Add add0(PC, 4, addout0);
    Add add1(PC, immediate, addout1);
    ALU alu(readData1, muxout0, ALUControl, ALUResult, zero);
    ALUControl alucontrol(instruction[14:12], ALUOp, ALUControl);
    Control control(instruction[6:0], Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    DataMemory datamemory(MemWrite, MemRead, ALUResult, readData2, readData3);
    Display display(PC, HEX0, HEX1);
    ImmGen immgen(instruction, immediate);
    InstructionMemory instructionmemory(PC, instruction);
    Mux mux0(ALUSrc, readData2, immediate, muxout0);
    Mux mux1(Branch & zero, addout0, addout1, muxout1);
    Mux mux2(MemtoReg, ALUResult, readData3, muxout2);
    PC pc(clk, reset, muxout1, PC);
    Registers registers(RegWrite, instruction[19:15], instruction[24:20], instruction[11:7], muxout2, readData1, readData2);

endmodule

//=======================================================
//  Display
//=======================================================

module Display (
    input wire [31:0] PC,
    output reg [6:0] HEX0,
    output reg [6:0] HEX1
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
        HEX0 = to_7seg(units_digit);
        HEX1 = to_7seg(tens_digit);
    end

endmodule

//=======================================================
//  ImmGen
//=======================================================

module ImmGen(
    input  wire [31:0] instruction,
    output reg [31:0] immediate
);

    localparam [6:0] TYPE_I  = 7'b0000011,
                     TYPE_Ii = 7'b0010011,
                     TYPE_S  = 7'b0100011, 
                     TYPE_SB = 7'b1100111;

    always @(*) begin
        case (instruction[6:0])
            TYPE_I: immediate = {{20{instruction[31]}}, instruction[31:20]};
            TYPE_Ii: immediate = {{20{instruction[31]}}, instruction[31:20]};
            TYPE_S: immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            TYPE_SB: immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
            default: immediate = 32'b0; 
        endcase
    end

endmodule

//=======================================================
//  InstructionMemory
//=======================================================

module InstructionMemory (
    input wire [31:0] readAddress,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:31];
	 
    initial begin
        memory[0] = 32'b00000000000000000001000001100111;
        memory[1] = 32'b00000000000000000000000010000011;
        memory[2] = 32'b00000000000100001000000100110011;
        memory[3] = 32'b00000000000100001111000110110011;
        memory[4] = 32'b00000010000000001110001000010011;
        memory[5] = 32'b00000000000100001001001010110011;
        memory[6] = 32'b00000000001000011000001100110011;
        memory[7] = 32'b00000000010000101000001110110011;
        memory[8] = 32'b00000000011000111000010000110011;
        memory[9] = 32'b00000000100000000000000010100011;
    end

    always @(*) begin
        instruction = memory[readAddress / 4];
    end

endmodule

//=======================================================
//  Mux
//=======================================================

module Mux (
    input wire Control,
    input wire [31:0] in0,
    input wire [31:0] in1,  
    output reg [31:0] out
);

    always @(*) begin
        if (Control) begin
            out = in1;
        end else begin
            out = in0;
        end
    end

endmodule

//=======================================================
//  PC
//=======================================================

module PC (
    input wire clk, reset, 
    input wire [31:0] PCIn,
    output reg [31:0] PCOut
);

    always @(posedge clk) begin
        if (reset) begin
            PCOut = 32'b0;
        end else begin
            PCOut = PCIn; 
        end
    end

endmodule

//=======================================================
//  Registers
//=======================================================

module Registers (
    input wire RegWrite,
    input wire [4:0] readReg1, readReg2,
    input wire [4:0] writeReg,
    input wire [31:0] writeData,
    output reg [31:0] readData1, readData2
);

    reg [31:0] registers [0:31];

    // always @(registers[0]) begin
    //     registers[0] = 0;
    // end

    always @(readReg1, registers[readReg1]) begin
        readData1 = registers[readReg1];
    end

    always @(readReg2, registers[readReg2]) begin
        readData2 = registers[readReg2];
    end

    always @(*) begin
        if (RegWrite) begin
            registers[writeReg] = writeData;
        end
    end

endmodule
