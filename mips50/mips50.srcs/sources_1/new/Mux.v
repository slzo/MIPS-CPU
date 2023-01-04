`timescale 1ns / 1ps
module ALUSrcMux(
	input wire [31:0] RData1,
	input wire [31:0] RData2,
	input wire [31:0] imm32,
	input wire ALUSrc1,
	input wire ALUSrc2,
	input wire [3:0] ALUSrc_RData1,
	input wire [3:0] ALUSrc_RData2,
	input wire [31:0] EX_MEM_ALUResult,
	input wire [31:0] MEM_WB_regWriteMux,
	output wire [31:0] Out1,
	output wire [31:0] Out2
	);
	
	assign Out1 = ALUSrc1 == 1 ? imm32 :
				  ALUSrc_RData1 == 1 ? EX_MEM_ALUResult :
				  ALUSrc_RData1 == 2 ? MEM_WB_regWriteMux :
				  RData1; 
	//必须保证先判断ALUSrc，因为可能并不需要转发过来的数据			  
	assign Out2 = ALUSrc2 == 1 ? imm32 :
				  (ALUSrc_RData2 == 1 ? EX_MEM_ALUResult :
				  ALUSrc_RData2 == 2 ? MEM_WB_regWriteMux :
				  RData2);
endmodule

module regWriteMux(
	input wire [31:0] PC,
	input wire [31:0] ALUResult,
	input wire [31:0] Data,
	input wire PCToReg,
	input wire MemToReg,
	output wire [31:0] Out
	);
	//assign Out = MemToReg == 1 ? Data :
	//			 PCToReg == 1 ? PC + 8 : ALUResult;
	assign Out = MemToReg == 1 ? Data : ALUResult;
endmodule
	
module PCSrcMux(
	input wire Cmp,
	input wire RsToPC,
	input wire J_imm26,
	input wire [31:0] Adder,
	input wire [31:0] NAdder,
	input wire [31:0] Shifter,
	input wire [31:0] RData1,
	input wire [3:0] PCSrc_RsToPC,
	input wire [31:0] ID_EX_PC,
	input wire [31:0] EX_MEM_ALUResult,
	input wire [31:0] MEM_WB_regWriteMux,
	output wire [31:0] Out
    );
	//括号内是RsToPC的转发机制
	assign Out = RsToPC == 1 ? (PCSrc_RsToPC == 1 ? EX_MEM_ALUResult :
				 PCSrc_RsToPC == 2 ? MEM_WB_regWriteMux : 
				 PCSrc_RsToPC == 3 ? ID_EX_PC + 8 :RData1) :
				 J_imm26 == 1 ? Shifter :
				 Cmp ? NAdder :
				 Adder;
endmodule

module CMPSrcMux(
	input wire [31:0] RData1,
	input wire [31:0] RData2,
	input wire [31:0] ID_EX_PC,
	input wire [31:0] EX_MEM_ALUResult,
	input wire [31:0] MEM_WB_regWriteMux,
	input wire [3:0] CMPSrc_rs,
	input wire [3:0] CMPSrc_rt,
	output wire [31:0] Out_rs,
	output wire [31:0] Out_rt
);
	//因为CMP模块没有别的控制信号，也就是说没有别的指令会使用，因此可以直接用转发信号控制
	assign Out_rs = CMPSrc_rs == 1 ? EX_MEM_ALUResult :
					CMPSrc_rs == 2 ? MEM_WB_regWriteMux :
					CMPSrc_rs == 3 ? ID_EX_PC + 8 :
					RData1;
	assign Out_rt = CMPSrc_rt == 1 ? EX_MEM_ALUResult :
					CMPSrc_rt == 2 ? MEM_WB_regWriteMux :
					CMPSrc_rt == 3 ? ID_EX_PC + 8 :
					RData2;
endmodule

module DMSrcMux(
	input wire [31:0] ID_EX_RData2,
	input wire [31:0] EX_MEM_ALUResult,
	input wire [31:0] MEM_WB_regWriteMux,
	input wire [3:0] DMSrc,
	output wire [31:0] Out
);

	assign Out = DMSrc == 1 ? EX_MEM_ALUResult :
				  DMSrc == 2 ? MEM_WB_regWriteMux :
				  ID_EX_RData2; 
endmodule	

module EX_ALUResultSrcMux(
	input wire [31:0] ALUResult,
	input wire [31:0] LT,
	input wire [31:0] ID_EX_PC,
	input wire [31:0] HI,
	input wire [31:0] LO,
	
	input wire [3:0] EX_ALUResultSrc,
	output wire [31:0] Out
);

	assign Out = EX_ALUResultSrc == 1 ? LT :
				 EX_ALUResultSrc == 2 ? ID_EX_PC + 8:
				 EX_ALUResultSrc == 3 ? HI :
				 EX_ALUResultSrc == 4 ? LO :
				 ALUResult;

endmodule

//module MDReDesMUX(
//		input wire [3:0] dessrc,
//		input wire [31:0] data,
//		output wire [31:0] HI, LO);
//	assign HI = dessrc==3'b000 ? data:HI;
//	assign LO = dessrc==3'b001 ? data:LO;
//endmodule
