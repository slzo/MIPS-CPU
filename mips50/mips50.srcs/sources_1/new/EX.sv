`timescale 1ns / 1ps
`include "MultiplicationDivisionUnit.sv"

module EX(
	input clk,
	input reset,
    input [31:0] Instr_E,
    input [31:0] imm32_E,
    input [31:0] WD_E,
    input [31:0] Forward_A_E,
    input [31:0] Forward_B_E,
    output [31:0] ALUOut_E_M,
    output [31:0] RD2_E_M,
	output [4:0] A3_E_M,
    output [31:0] WD_E_M,
	input [1:0] Tnew_E,
	output [1:0] Tnew_E_M,
	output start,
	output busy
    );
	wire [31:0] ALUB_E,ALUA_E,HI,LO,MDUOut;
	wire [1:0] WDSel_E,WRSel_E;
	wire [4:0] A3_E;
	wire [3:0] ALUOp_E;
	wire BSel_E,RFWr_E,ASel_E;
	wire [2:0] MDUOp_E;
	wire HILOSel;
	assign RD2_E_M = Forward_B_E;
	assign Tnew_E_M = (Tnew_E != 0) ? (Tnew_E - 1) : 0;
	ControllerUnit Controller_E(
		.instr(Instr_E),
		.ASel(ASel_E),
		.BSel(BSel_E),
		.ALUOp(ALUOp_E),
		.WRSel(WRSel_E),
		.WDSel(WDSel_E),
		.MDUOp(MDUOp_E),
		.RFWr(RFWr_E),
		.start(start),
		.HILOSel(HILOSel)
	);
	
	MUX2to1 MALUB_E(
		.D0(Forward_B_E),
		.D1(imm32_E),
		.Sel(BSel_E),
		.Out(ALUB_E)
	);
	MUX2to1 MALUA_E(
		.D0(Forward_A_E),
		.D1({27'b0, Instr_E[10:6]}),
		.Sel(ASel_E),
		.Out(ALUA_E)
	);
	
	
	ALU ALU_Instance(
		.A(ALUA_E),
		.B(ALUB_E),
		.C(ALUOut_E_M),
		.ALUOp(ALUOp_E)
	);
	wire [31:0] mdure;
	MultiplicationDivisionUnit MDU(
		.clock(clk),
		.reset(reset),
		.start(start & !busy),
		.operation(mdu_operation_t'(MDUOp_E)),
		.operand1(ALUA_E),
		.operand2(ALUB_E),
		.busy(busy),
		.dataRead(mdure)
    );
    assign HI = MDUOp_E==3'b000 ? mdure:HI;
    assign LO = MDUOp_E==3'b001 ? mdure:LO;
	MUX2to1 MMDUOut(
		.D0(LO),
		.D1(HI),
		.Sel(HILOSel),
		.Out(MDUOut)
	);
	MUX4to1 MWD_E_M(
		.D0(ALUOut_E_M),
		.D1(32'hffffffff),
		.D2(WD_E),
		.D3(MDUOut),
		.Sel(WDSel_E),
		.Out(WD_E_M)
	);
	MUX3to1 MA3_E(
		.D0(Instr_E[15:11]),
		.D1(Instr_E[20:16]),
		.D2(5'd31),
		.Sel(WRSel_E),
		.Out(A3_E)
	);
	defparam MA3_E.WIDTH_DATA = 5;
	assign A3_E_M = (RFWr_E == 1 ) ? A3_E : 0;
	
endmodule