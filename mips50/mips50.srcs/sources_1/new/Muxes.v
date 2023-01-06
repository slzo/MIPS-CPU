`timescale 1ns / 1ps

module MUX2to1(D0, D1, Sel, Out);

	parameter WIDTH_DATA = 32;
	
	input [WIDTH_DATA : 1] D0;
    input [WIDTH_DATA : 1] D1;
    input Sel;
    output [WIDTH_DATA : 1] Out;
	assign Out = (Sel == 0) ? D0 :
	             (Sel == 1) ? D1 :
							32'hffffffff;
endmodule

module MUX3to1(D0, D1, D2, Sel, Out);

	parameter WIDTH_DATA = 32;
	
	input [WIDTH_DATA - 1:0] D0;
	input [WIDTH_DATA - 1:0] D1;
	input [WIDTH_DATA - 1:0] D2;
	input [1:0] Sel;
	output [WIDTH_DATA - 1:0] Out;
	assign Out = (Sel == 0) ? D0 :
	             (Sel == 1) ? D1 :
				 (Sel == 2) ? D2 :
							32'hffffffff;

endmodule

module MUX4to1(D0, D1, D2, D3, Sel, Out);
	parameter WIDTH_DATA = 32;
	
	input [WIDTH_DATA - 1:0] D0;
	input [WIDTH_DATA - 1:0] D1;
	input [WIDTH_DATA - 1:0] D2;
	input [WIDTH_DATA - 1:0] D3;
	input [1:0] Sel;
	output [WIDTH_DATA - 1:0] Out;
	assign Out = (Sel == 0) ? D0 :
	             (Sel == 1) ? D1 :
				 (Sel == 2) ? D2 :
				 (Sel == 3) ? D3 :
							32'hffffffff;
endmodule
