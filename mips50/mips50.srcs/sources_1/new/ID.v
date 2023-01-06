`timescale 1ns / 1ps

module ID(
    input [31:0] PC_D,//
    input [31:0] PC4_D,//
    input [31:0] Instr_D,//
    input clk,//
    input reset,//
    input [31:0] Forward_A_D,//
    input [31:0] Forward_B_D,//
    input [31:0] PC_W,//
    input [4:0] A3_W,//
    input [31:0] WD_W,//
    input [31:0] Instr_W,//
    output [31:0] RD1_D_E,//
    output [31:0] RD2_D_E,//
    output [31:0] imm32_D_E,//
    output [4:0] A3_D_E,//
    output [31:0] WD_D_E,//
    output [2:0] NPCOp_D,//
    output [31:0] NPC_D,//
	output [1:0] TuseA,
	output [1:0] TuseB,
	output [1:0] Tnew_D_E,
	output [31:0] WD_W_real,
	output isMD,
	input [31:0] ALUOut_W
    );
	wire [1:0] EXTOp_D,WRSel_D,WDSel_D;
	wire RFWr_W,Equal_D,RFWr_D;
	wire [31:0] PC8_D;
	wire [4:0] A3_D;
	wire [31:0] pc;
	wire [2:0] LSel_W,CMPOp_D;
	assign PC8_D = PC4_D + 4;
	ControllerUnit Controller_D(
		.instr(Instr_D),
		.EXTOp(EXTOp_D),
		.NPCOp(NPCOp_D),
		.WRSel(WRSel_D),
		.WDSel(WDSel_D),
		.RFWr(RFWr_D),
		.Tnew(Tnew_D_E),
		.TuseA(TuseA),
		.TuseB(TuseB),
		.CMPOp(CMPOp_D),
		.isMD(isMD)
	);
	ControllerUnit Controller_W(
		.instr(Instr_W),
		.RFWr(RFWr_W),
		.LSel(LSel_W)
	);
	NPC NPC_Instance(
		.RA(Forward_A_D),
		.imm26(Instr_D[25:0]),
		.NPC(NPC_D),
		.PC(PC_D),
		.NPCOp(NPCOp_D),
		.Equal(Equal_D)
	);
	Comparator CMP(
		.A(Forward_A_D),
		.B(Forward_B_D),
		.CMPOp(CMPOp_D),
		.Equal(Equal_D)
	);
	MemExt EXT_Instance(
		.EXTOp(EXTOp_D),
		.imm16(Instr_D[15:0]),
		.imm32(imm32_D_E)
	);
	GeneralRegister GR(
		.A1(Instr_D[25:21]),
		.A2(Instr_D[20:16]),
		.A3(A3_W),
		.WD(WD_W_real),
		.WE(RFWr_W),
		.PC(PC_W),
		.clk(clk),
		.reset(reset),
		.V1(RD1_D_E),
		.V2(RD2_D_E)
	);
	MUX3to1 MA3_D(
		.D0(Instr_D[15:11]),
		.D1(Instr_D[20:16]),
		.D2(5'd31),
		.Sel(WRSel_D),
		.Out(A3_D)
	);
	defparam MA3_D.WIDTH_DATA = 5;
	assign A3_D_E = (RFWr_D == 1 ) ? A3_D : 0;
	
	
	MUX4to1 MWD_D(
		.D0(32'hffffffff),
		.D1(32'hffffffff),
		.D2(PC8_D),
		.D3(32'hffffffff),
		.Sel(WDSel_D),
		.Out(WD_D_E)
	);
	
	DwBits DWBits_Instance(
		.DWRD_W(WD_W),
		.LSel_W(LSel_W),
		.DWOut(WD_W_real),
		.A(ALUOut_W)
	);

endmodule

