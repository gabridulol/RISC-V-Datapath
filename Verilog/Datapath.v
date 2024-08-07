module Datapath_Testbench;
    reg clk, reset;

    Datapath datapath(clk, reset);

    initial begin
        // Load memory files
        $readmemb("Verilog/Input/InstructionMemory.mem", datapath.instructionmemory.memory);
        $readmemb("Verilog/Input/DataMemory.mem", datapath.datamemory.memory);
        $readmemb("Verilog/Input/Registers.mem", datapath.registers.registers);
        
        // Print memory contents
        $display("Instruction Memory Contents:");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("instructionmemory[%0d] = %h", i, datapath.instructionmemory.memory[i]);
        end

        $display("Data Memory Contents:");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("datamemory[%0d] = %h", i, datapath.datamemory.memory[i]);
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
    
    InstructionMemory instructionmemory();
    DataMemory datamemory();
    Registers registers();

endmodule