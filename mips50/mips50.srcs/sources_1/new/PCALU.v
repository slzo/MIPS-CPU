`timescale 1ns / 1ps
`include "Defines.v"

module Adder(
    input [31:0] PC,
    output [31:0] PC4
    );
	assign PC4 = PC + 4;

endmodule

module NPC(
    input [31:0] RA,
    input [25:0] imm26,
    output [31:0] NPC,
    input [31:0] PC,
    input [2:0] NPCOp,
    input Equal
    );
	assign NPC = (NPCOp == `NPC_PC4) ? (PC + 4) :
				 (NPCOp == `NPC_Br)  ? (Equal ? (PC + 4 + {{14{imm26[15]}}, imm26[15:0], 2'b0}) : PC + 8) :
				 (NPCOp == `NPC_J)   ? ({PC[31:28], imm26, 2'b00}) :
				 (NPCOp == `NPC_JR)  ? RA : 32'h0;
endmodule