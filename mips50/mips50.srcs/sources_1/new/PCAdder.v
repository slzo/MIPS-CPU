`timescale 1ns / 1ps
module PCAdder(
	input wire [31:0] PC,
	output wire [31:0] Out
    );
	assign Out = PC + 32'h4;
endmodule
module NAdder(
	input wire [31:0] Shifter,
	input wire [31:0] PC,
	output wire [31:0] Out
    );
	assign Out = Shifter + PC + 4;
endmodule
module Shifter(
    input wire [31:0] EXT,
	output wire [31:0] Out
    );
	assign Out = EXT << 2;
endmodule