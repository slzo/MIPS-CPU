`timescale 1ns / 1ps

module InstructionMemory(
    input wire [13:2] Addr,
	output reg [31:0] Out
    );
	
	reg [31:0] instructions [0:4095];
	
	initial begin
		$readmemh("/home/soda/cpu/pipline/Mips50TestCodeAns/TestCode/HexadecimalCode/0hJ.asm.txt", instructions);
	end

	always @(*) begin
		Out = instructions[Addr - 12'hc00];
//		if( Out[31:26]==6'b000000 && Out[5:0]==6'b001100 )
//		  $finish;
	end

	

endmodule
