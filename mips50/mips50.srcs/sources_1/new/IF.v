`timescale 1ns / 1ps

module IF(
    input [2:0] NPCOp_D,
    input [31:0] NPC_D,
    input clk,
    input reset,
    input PCEn,
    output [31:0] PC_F_D,
	output [31:0] PC4_F_D,
    output [31:0] Instr_F_D
    );
	wire [31:0] pc_F,npc_F;
	wire MUX_NPCSel;
	assign MUX_NPCSel = |NPCOp_D;
	ProgramCounter PC_Instance(
		.clk(clk),
		.reset(reset),
		.En(PCEn),
		.NPC(npc_F),
		.PC(PC_F_D)
	);
	Adder Adder_Instance(
		.PC(PC_F_D),
		.PC4(PC4_F_D)
	);
	MUX2to1 MUX_NPC(
		.D0(PC4_F_D),
		.D1(NPC_D),
		.Sel(MUX_NPCSel),
		.Out(npc_F)
	);
	InstructionMemory IM_Instance(
		.address(PC_F_D),
		.instr(Instr_F_D)
	);
endmodule
