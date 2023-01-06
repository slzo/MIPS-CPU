`timescale 1ns / 1ps

module ForwardUnit(
    input [4:0] A1_D,
    input [4:0] A2_D,
    input [31:0] RD1_D,
    input [31:0] RD2_D,
    input [4:0] A1_E,
    input [4:0] A2_E,
    input [31:0] RD1_E,
    input [31:0] RD2_E,
    input [4:0] A3_E,
    input [31:0] WD_E,
    input [4:0] A3_M,
    input [31:0] WD_M,
    input [4:0] A3_W,
    input [31:0] WD_W,
	input [4:0] A2_M,
	input [31:0] RD2_M,
    output [31:0] Forward_A_D,
    output [31:0] Forward_B_D,
    output [31:0] Forward_A_E,
    output [31:0] Forward_B_E,
    output [31:0] Forward_DMWD_M,
	input [1:0] Tnew_E,
	input [1:0] Tnew_M
    );
	assign Forward_A_D = (A1_D == A3_E && A3_E != 0 && Tnew_E == 0) ? WD_E :
						 (A1_D == A3_M && A3_M != 0 && Tnew_M == 0) ? WD_M :
						 (A1_D == A3_W && A3_W != 0 ) ? WD_W :
													RD1_D;
													
	assign Forward_B_D = (A2_D == A3_E && A3_E != 0 && Tnew_E == 0) ? WD_E :
						 (A2_D == A3_M && A3_M != 0 && Tnew_M == 0) ? WD_M :
						 (A2_D == A3_W && A3_W != 0 ) ? WD_W :
													RD2_D;
	assign Forward_A_E = (A1_E == A3_M && A3_M != 0 && Tnew_M == 0) ? WD_M :
						 (A1_E == A3_W && A3_W != 0) ? WD_W :						
													RD1_E;
	assign Forward_B_E = (A2_E == A3_M && A3_M != 0 && Tnew_M == 0) ? WD_M :
						 (A2_E == A3_W && A3_W != 0) ? WD_W :						
													RD2_E;
	assign Forward_DMWD_M = (A2_M == A3_W && A3_W != 0) ? WD_W : RD2_M;
													
endmodule
