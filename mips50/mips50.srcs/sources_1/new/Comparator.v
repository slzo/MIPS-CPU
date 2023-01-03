`timescale 1ns / 1ps

module Comparator(
	input wire [31:0] RData1,
	input wire [31:0] RData2,
	input wire [3:0] Branch,
	output wire Cmp
    );
	assign Cmp = Branch == 4'h1 & RData1 == RData2 |
				 Branch == 4'h2 & RData1 != RData2 |
				 Branch == 4'h3 & $signed(RData1) < 0 |
				 Branch == 4'h4 & $signed(RData1) <= 0 |
				 Branch == 4'h5 & $signed(RData1) > 0 |
				 Branch == 4'h6 & $signed(RData1) >= 0;
endmodule
