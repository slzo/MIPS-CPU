`timescale 1ns / 1ps
`include "Defines.v"

module Comparator(
    input [31:0] A,
    input [31:0] B,
	input [2:0] CMPOp,
    output Equal
    );
	assign Equal = (CMPOp == `CMP_BEQ) ? (A == B) : 
				   (CMPOp == `CMP_BNE) ? (A != B) :
				   (CMPOp == `CMP_BLEZ)? ($signed(A)<=$signed(0)):
				   (CMPOp == `CMP_BGTZ)? ($signed(A)>$signed(0)):
				   (CMPOp == `CMP_BLTZ)? ($signed(A)<$signed(0)):
				   (CMPOp == `CMP_BGEZ)? ($signed(A)>=$signed(0)):0;





endmodule
