`timescale 1ns / 1ps

module MEM(
    input [31:0] Instr_M,
    input [31:0] ALUOut_M,
    input [31:0] Forward_DMWD_M,
    input [31:0] WD_M,
    input [31:0] PC_M,
    output [4:0] A3_M_W,
    output [31:0] WD_M_W,
    input clk,
    input reset
    );
	wire [1:0] SSel_M,LSel_M,WDSel_M,WRSel_M;
	wire DMWr_M;
	wire [4:0] A3_M;
	wire [31:0] DMRD_M;
	wire RFWr_M;
	ControllerUnit Controller_M(
		.instr(Instr_M),
		.SSel(SSel_M),
		.DMWr(DMWr_M),
		.WDSel(WDSel_M),
		.WRSel(WRSel_M),
		.RFWr(RFWr_M)
	);
	DataMemory DM_Instance(
		.clk(clk),
		.reset(reset),
		.WE(DMWr_M),
		.PC(PC_M),
		.A(ALUOut_M&14'h3fff),
		.WD(Forward_DMWD_M),
		.RD(DMRD_M),
		.SSel(SSel_M)
	);
	MUX4to1 MWD_M_W(
		.D0(WD_M),
		.D1(DMRD_M),
		.D2(WD_M),
		.D3(WD_M),
		.Sel(WDSel_M),
		.Out(WD_M_W)
	);
	MUX3to1 MA3_M(
		.D0(Instr_M[15:11]),
		.D1(Instr_M[20:16]),
		.D2(5'd31),
		.Sel(WRSel_M),
		.Out(A3_M)
	);
	defparam MA3_M.WIDTH_DATA = 5;
	assign A3_M_W = (RFWr_M == 1) ? A3_M : 0;

endmodule