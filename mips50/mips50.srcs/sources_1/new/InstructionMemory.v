`timescale 1ns / 1ps

module InstructionMemory(
    input [31:0] address,
    output [31:0] instr
    );
	reg [31:0] instructions [0:4095];
	initial $readmemh("/home/soda/cpu/pipline/Mips50TestCodeAns/TestCode/HexadecimalCode/88H.asm.txt", instructions);
	assign instr = instructions[address[13:2]-12'hc00];
endmodule
