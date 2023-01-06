`timescale 1ns / 1ps
`include "Defines.v"

module ALU(
    input [31:0] A,
    input [31:0] B,
    output [31:0] C,
    input [3:0] ALUOp
    );
	assign C = (ALUOp == `ALU_ADD)  ? (A + B) :
			   (ALUOp == `ALU_SUB)  ? (A - B) :
			   (ALUOp == `ALU_OR)   ? (A | B) :
			   (ALUOp == `ALU_SLL)  ? (B << A[4:0]) :
			   (ALUOp == `ALU_SLT)  ? (($signed(A) < $signed(B)) ? 1 : 0) :
			   (ALUOp == `ALU_SLTU) ? ((A < B) ? 1 : 0) :
			   (ALUOp == `ALU_AND)  ? (A & B) :
			   (ALUOp == `ALU_NOR)  ? ~(A | B) :
			   (ALUOp == `ALU_XOR)  ? (A ^ B) :
			   (ALUOp == `ALU_SRA)  ? $signed(($signed(B) >>> A[4:0])) :
			   (ALUOp == `ALU_SRL)  ? (B >> A[4:0]) : 32'hffffffff;


endmodule