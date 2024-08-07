module Datapath_tb;
    reg clk, reset;
    reg [31:0] PCIn;
    wire [31:0] PCOut;
    wire [31:0] Instruction;

    // Instâncias dos módulos
    PC uutPC (
        .clk(clk),
        .reset(reset),
        .PCIn(PCIn),
        .PCOut(PCOut)
    );

    InstructionMemory uutInstructionMemory (
        .ReadAddress(PCOut),
        .Instruction(Instruction)
    );

    // Gerador de clock
    always begin
        #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Sequência de inicialização e teste
    initial begin
        // Inicialização
        clk = 0;
        reset = 0;

        // Aplicar reset
        reset = 1;
        #10;
        reset = 0;

        // Teste 1
        #10;
        PCIn = 32'h00000000;
        #10;
        $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

        // Teste 2
        #10;
        PCIn = 32'h00000004;
        #10;
        $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

        // Teste 3
        #10;
        PCIn = 32'h00000008;
        #10;
        $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

        // Teste 4
        #10;
        PCIn = 32'h0000000C;
        #10;
        $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

        // Teste 5
        #10;
        PCIn = 32'h00000010;
        #10;
        $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

        // Teste 6
        #10;
        PCIn = 32'h00000014;
        #10;
        $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

        // Teste 7
        #10;
        PCIn = 32'h00000018;
        #10;
        $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

        // Teste 8
        #10;
        PCIn = 32'h0000001C;
        #10;
        $display("Time = %0t | PCIn = %h | PCOut = %h | Instruction = %b", $time, PCIn, PCOut, Instruction);

        // Finalização do teste
        #10;
        $finish;
    end

endmodule
