`timescale 1ns / 1ps
module IF_ID_Reg(
    input [31:0] PC_F_D,
    input [31:0] PC4_F_D,
    input [31:0] Instr_F_D,
    input clk,
    input reset,
    input F_D_RegEn,
    output reg [31:0] PC_D,
    output reg [31:0] PC4_D,
    output reg [31:0] Instr_D
    );
	initial begin
		PC_D <= 0;
		PC4_D <= 0;
		Instr_D <= 0;
	end
	always @(posedge clk) begin
		if(reset) begin
			PC_D <= 0;
			PC4_D <= 0;
			Instr_D <= 0;
		end
		else if(F_D_RegEn) begin
				PC_D <= PC_F_D;
				PC4_D <= PC4_F_D;
				Instr_D <= Instr_F_D;
		end
		else begin end
	end
endmodule


module ID_EX_Reg(
    input Flush_E,
    input clk,
    input reset,
    input [31:0] Instr_D,
    input [31:0] RD1_D_E,
    input [31:0] RD2_D_E,
    input [31:0] imm32_D_E,
    input [4:0] A3_D_E,
    input [31:0] WD_D_E,
    output reg [31:0] Instr_E,
    output reg [31:0] RD1_E,
    output reg [31:0] RD2_E,
    output reg [31:0] imm32_E,
    output reg [4:0] A3_E,
    output reg [31:0] WD_E,
    input [31:0] PC_D,
    output reg [31:0] PC_E,
	input [1:0] Tnew_D_E,
	output reg [1:0] Tnew_E
    );
	initial begin
		Instr_E <= 0;
		RD1_E <= 0;
		RD2_E <= 0;
		imm32_E <= 0;
		A3_E <= 0;
		WD_E <= 0;
		PC_E <= 0;
		Tnew_E <= 0;
	end
	always @(posedge clk) begin
		if(reset || Flush_E) begin
			Instr_E <= 0;
			RD1_E <= 0;
			RD2_E <= 0;
			imm32_E <= 0;
			A3_E <= 0;
			WD_E <= 0;
			PC_E <= 0;
			Tnew_E <= 0;
		end
		else begin
			Instr_E <= Instr_D;
			RD1_E <= RD1_D_E;
			RD2_E <= RD2_D_E;
			imm32_E <= imm32_D_E;
			A3_E <= A3_D_E;
			WD_E <= WD_D_E;
			PC_E <= PC_D;
			Tnew_E <= Tnew_D_E ;
		end
	end
endmodule

module EX_MEM_Reg(
    input clk,
    input reset,
    input [31:0] Instr_E,
    input [31:0] ALUOut_E_M,
    input [31:0] RD2_E_M,
    input [31:0] WD_E_M,
    input [31:0] PC_E,
    input [4:0] A3_E_M,
    output reg [31:0] Instr_M,
    output reg [31:0] ALUOut_M,
    output reg [31:0] RD2_M,
    output reg [31:0] WD_M,
    output reg [31:0] PC_M,
    output reg [4:0] A3_M,
	input [1:0] Tnew_E_M,
	output reg [1:0] Tnew_M
    );
	initial begin
		Instr_M <= 0;
		ALUOut_M <= 0;
		RD2_M <= 0;
		WD_M <= 0;
		PC_M <= 0;
		A3_M <= 0;
		Tnew_M <= 0;
	end
	always @(posedge clk) begin
		if(reset) begin
			Instr_M <= 0;
			ALUOut_M <= 0;
			RD2_M <= 0;
			WD_M <= 0;
			PC_M <= 0;
			A3_M <= 0;
			Tnew_M <= 0;
		end
		else begin
			Instr_M <= Instr_E;
			ALUOut_M <= ALUOut_E_M;
			RD2_M <= RD2_E_M;
			WD_M <= WD_E_M;
			PC_M <= PC_E;
			A3_M <= A3_E_M;
			Tnew_M <= Tnew_E_M;
		end
	end
endmodule

module MEM_WB_Reg(
    input clk,
    input reset,
    input [4:0] A3_M_W,
	input [31:0] ALUOut_M,
	output reg [31:0] ALUOut_W,
    output reg [4:0] A3_W,
    input [31:0] WD_M_W,
    input [31:0] PC_M,
    output reg [31:0] PC_W,
    output reg [31:0] WD_W,
    input [31:0] Instr_M,
    output reg [31:0] Instr_W
    );
	initial begin
		A3_W <= 0;
		PC_W <= 0;
		WD_W <= 0;
		Instr_W <= 0;
		ALUOut_W <= 0;
	end
	always @(posedge clk)begin
		if(reset) begin
			A3_W <= 0;
			PC_W <= 0;
			WD_W <= 0;
			Instr_W <= 0;
			ALUOut_W <= 0;
		end
		else begin
			A3_W <= A3_M_W;
			PC_W <= PC_M;
			WD_W <= WD_M_W;
			Instr_W <= Instr_M;
			ALUOut_W <= ALUOut_M;
		end
	end
endmodule