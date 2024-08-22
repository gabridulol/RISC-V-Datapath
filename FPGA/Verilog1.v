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
    input wire clk, reset,
    input wire MemWrite, MemRead,
    input wire [31:0] address,
    input wire [31:0] writeData,
    output reg [31:0] readData
);

    reg [31:0] memory [0:31];

    always @(*) begin
        if (reset) begin
            memory[0] = 32'b00000000000000000000000000000100;
            memory[1] = 32'b0;
            memory[2] = 32'b0;
            memory[3] = 32'b0;
            memory[4] = 32'b0;
            memory[5] = 32'b0;
            memory[6] = 32'b0;
            memory[7] = 32'b0;
            memory[8] = 32'b0;
            memory[9] = 32'b0;
            memory[10] = 32'b0;
            memory[11] = 32'b0;
            memory[12] = 32'b0;
            memory[13] = 32'b0;
            memory[14] = 32'b0;
            memory[15] = 32'b0;
            memory[16] = 32'b0;
            memory[17] = 32'b0;
            memory[18] = 32'b0;
            memory[19] = 32'b0;
            memory[20] = 32'b0;
            memory[21] = 32'b0;
            memory[22] = 32'b0;
            memory[23] = 32'b0;
            memory[24] = 32'b0;
            memory[25] = 32'b0;
            memory[26] = 32'b0;
            memory[27] = 32'b0;
            memory[28] = 32'b0;
            memory[29] = 32'b0;
            memory[30] = 32'b0;
            memory[31] = 32'b0;
        end if (MemRead) begin
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
    input wire clk, reset,
    output reg [31:0] ProgramCounter
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
    wire zero;

    Add add0(PC, 4, addout0);
    Add add1(PC, immediate, addout1);
    ALU alu(readData1, muxout0, ALUControl, ALUResult, zero);
    ALUControl alucontrol(instruction[14:12], ALUOp, ALUControl);
    Control control(instruction[6:0], Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
    DataMemory datamemory(clk, reset, MemWrite, MemRead, ALUResult, readData2, readData3);
    ImmGen immgen(instruction, immediate);
    InstructionMemory instructionmemory(clk, reset, PC, instruction);
    Mux mux0(ALUSrc, readData2, immediate, muxout0);
    Mux mux1(Branch & zero, addout0, addout1, muxout1);
    Mux mux2(MemtoReg, ALUResult, readData3, muxout2);
    PC pc(clk, reset, muxout1, PC);
    Registers registers(clk, reset, RegWrite, instruction[19:15], instruction[24:20], instruction[11:7], muxout2, readData1, readData2);

    always @(posedge clk) begin
        ProgramCounter <= PC;
    end

endmodule

//=======================================================
//  Display
//=======================================================

module Display (
    input wire [31:0] PC,
    output reg [6:0] HEX0,
    output reg [6:0] HEX1
);

    always @(PC) begin
        if (PC <= 124) begin
            case ((PC / 4) % 10)
                4'd0: HEX0 = 7'b1000000; // 0
                4'd1: HEX0 = 7'b1111001; // 1
                4'd2: HEX0 = 7'b0100100; // 2
                4'd3: HEX0 = 7'b0110000; // 3
                4'd4: HEX0 = 7'b0011001; // 4
                4'd5: HEX0 = 7'b0010010; // 5
                4'd6: HEX0 = 7'b0000010; // 6
                4'd7: HEX0 = 7'b1111000; // 7
                4'd8: HEX0 = 7'b0000000; // 8
                4'd9: HEX0 = 7'b0010000; // 9
                default: HEX0 = 7'b1111111; // Error
            endcase
            case ((PC / 4) / 10)
                4'd0: HEX1 = 7'b1000000; // 0
                4'd1: HEX1 = 7'b1111001; // 1
                4'd2: HEX1 = 7'b0100100; // 2
                4'd3: HEX1 = 7'b0110000; // 3
                4'd4: HEX1 = 7'b0011001; // 4
                4'd5: HEX1 = 7'b0010010; // 5
                4'd6: HEX1 = 7'b0000010; // 6
                4'd7: HEX1 = 7'b1111000; // 7
                4'd8: HEX1 = 7'b0000000; // 8
                4'd9: HEX1 = 7'b0010000; // 9
                default: HEX1 = 7'b1111111; // Error
            endcase
        end
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
    input wire clk, reset,
    input wire [31:0] readAddress,
    output reg [31:0] instruction
);

    reg [31:0] memory [0:31];

    always @(*) begin
        if (reset) begin
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
            PCOut <= 32'b0;
        end else begin
            PCOut <= PCIn; 
        end
    end

endmodule

//=======================================================
//  Registers
//=======================================================

module Registers (
	input clk, reset,
    input wire RegWrite,
    input wire [4:0] readReg1, readReg2,
    input wire [4:0] writeReg,
    input wire [31:0] writeData,
    output reg [31:0] readData1, readData2
);

    reg [31:0] registers [0:31];

    always @(readReg1, registers[readReg1]) begin
        readData1 = registers[readReg1];
    end

    always @(readReg2, registers[readReg2]) begin
        readData2 = registers[readReg2];
    end

    always @(*) begin
        if (reset) begin
            registers[0] = 32'b0;
            registers[1] = 32'b0;
            registers[2] = 32'b0;
            registers[3] = 32'b0;
            registers[4] = 32'b0;
            registers[5] = 32'b0;
            registers[6] = 32'b0;
            registers[7] = 32'b0;
            registers[8] = 32'b0;
            registers[9] = 32'b0;
            registers[10] = 32'b0;
            registers[11] = 32'b0;
            registers[12] = 32'b0;
            registers[13] = 32'b0;
            registers[14] = 32'b0;
            registers[15] = 32'b0;
            registers[16] = 32'b0;
            registers[17] = 32'b0;
            registers[18] = 32'b0;
            registers[19] = 32'b0;
            registers[20] = 32'b0;
            registers[21] = 32'b0;
            registers[22] = 32'b0;
            registers[23] = 32'b0;
            registers[24] = 32'b0;
            registers[25] = 32'b0;
            registers[26] = 32'b0;
            registers[27] = 32'b0;
            registers[28] = 32'b0;
            registers[29] = 32'b0;
            registers[30] = 32'b0;
            registers[31] = 32'b0;
        end if (RegWrite) begin
            registers[writeReg] = writeData;
        end
    end

endmodule