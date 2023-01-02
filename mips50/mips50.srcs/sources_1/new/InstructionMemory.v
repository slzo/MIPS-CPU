`timescale 1ns / 1ps

module InstructionMemory( input [11:0] address, output [31:0] instruction );
    reg [31:0] instructionmemory[1023:0];
    initial begin
        $readmemh("/home/soda/cpu/pipline", instructionmemory);
    end
    assign instruction = instructionmemory[address-12'hc00];
endmodule
