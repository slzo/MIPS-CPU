`timescale 1ns / 1ps
`include "Defines.v"

module GeneralRegister(
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WD,
    output [31:0] V1,
    output [31:0] V2,
    input clk,
    input reset,
    input WE,
	input [31:0] PC
    );
	reg [31:0] rf[31:1];
	integer i, file;
	initial begin
	    file = $fopen("/home/soda/cpu/pipline/Mips50TestCodeAns/TestAns/myans.txt");
//        file = 1;
		for (i=1;i<32;i = i + 1) begin
				rf[i] = 32'h00000000;
			end
	end
	always @(posedge clk) begin
		if(reset == 1) begin
			for (i=1;i<32;i = i + 1) begin
				rf[i] <= 32'h00000000;
			end
		end
		else begin
			if( WE == 1 ) begin
                $fdisplay(file, "@%h: $%d <= %h",PC, A3, WD);
			    if(A3 != 0)
				    rf[A3] <= WD;
			end
		end
	end
	assign V1 = (A1 == A3 && WE && A3 != 0) ? WD : ((A1 == 0) ? 32'b0 : rf[A1]);
	assign V2 = (A2 == A3 && WE && A3 != 0) ? WD : ((A2 == 0) ? 32'b0 : rf[A2]);

endmodule
