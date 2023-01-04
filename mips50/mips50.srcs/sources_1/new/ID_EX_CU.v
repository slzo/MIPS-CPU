`timescale 1ns / 1ps
`include "Define.v"

module ID_EX_CU(
	input wire [31:0] ID_EX_Instr,
	input wire [4:0] EX_MEM_WAddr,
	input wire [4:0] MEM_WB_WAddr,
	
	input wire Busy,
	
	
	output wire [3:0] ALUOp,
	output wire ALUSrc1, ALUSrc2,       // to seperate the transmit and the data path
	output wire CalcuSigned,
	output wire [2:0] MDOp,
	output wire [3:0] EX_ALUResultSrc,
	
	
	output wire [3:0] ALUSrc_RData1,// set two ALUSrc
	output wire [3:0] ALUSrc_RData2,
	output wire [3:0] DMSrc,
	output wire [3:0] Tnew,
	
	output wire Install,
	output wire start
    );
	
	//控制转发	
	wire [5:0] Op = ID_EX_Instr[31:26];
	wire [5:0] Func = ID_EX_Instr[5:0];	
	
	assign start = !Busy & Op==`CALCU &(Func == `MULT_FUNC | Func == `MULTU_FUNC| Func == `DIV_FUNC | Func == `DIVU_FUNC );
	assign MDOp = Op==`CALCU ?
	              Func==`MFHI_FUNC?3'b000:
	              Func==`MFLO_FUNC?3'b001:
	              Func==`MTHI_FUNC?3'b010:
	              Func==`MTLO_FUNC?3'b011:
	              Func==`MULT_FUNC?3'b100:
	              Func==`MULTU_FUNC?3'b101:
	              Func==`DIV_FUNC?3'b110:
	              Func==`DIVU_FUNC?3'b111:
	              MDOp : MDOp;
	assign CalcuSigned = Op == `ADDI | Op == `SLTI | Op == `CALCU &
						 Func == `ADD_FUNC | Func == `SUB_FUNC | Func == `SLT_FUNC |
						 Func == `MULT_FUNC | Func == `DIV_FUNC;
	assign ALUSrc1 = Op == `CALCU & (Func == `SLL_FUNC | Func == `SRL_FUNC | Func == `SRA_FUNC);
	
	assign ALUSrc2 = Op == `ORI | Op == `ADDI | Op == `ADDIU | Op == `ANDI |
					Op == `XORI | Op == `LUI | Op == `LB | Op == `LBU |
					Op == `LH | Op == `LHU | Op == `LW | Op == `SB |
					Op == `SH | Op == `SW | Op == `SLTI | Op == `SLTIU;
	assign EX_ALUResultSrc = Op == `CALCU & (Func == `SLT_FUNC | Func == `SLTU_FUNC) |
							 Op == `SLTI | Op == `SLTIU ? 4'h1 :
							 Op == `JAL | Op == `CALCU & Func == `JALR_FUNC ? 4'h2 :
							 Op == `CALCU & Func == `MFHI_FUNC ? 4'h3 :
							 Op == `CALCU & Func == `MFLO_FUNC ? 4'h4 : 4'h0;
	assign ALUOp = Op == `CALCU & (Func == `ADD_FUNC | Func == `ADDU_FUNC) | Op == `ADDI ? 4'h0 :
				   Op == `CALCU & (Func == `SUB_FUNC | Func == `SUBU_FUNC) ? 4'h1 :
				   Op == `CALCU & Func == `OR_FUNC | Op == `ORI ? 4'h2 :
				   Op == `CALCU & Func == `AND_FUNC | Op == `ANDI ? 4'h3 :
				   Op == `CALCU & Func == `XOR_FUNC | Op == `XORI ? 4'h4 :
				   Op == `CALCU & Func == `NOR_FUNC ? 4'h5 :
				   Op == `CALCU & (Func == `SLL_FUNC | Func == `SLLV_FUNC) ? 4'h6 :
				   Op == `CALCU & (Func == `SRL_FUNC | Func == `SRLV_FUNC) ? 4'h7 :
				   Op == `CALCU & (Func == `SRA_FUNC | Func == `SRAV_FUNC) ? 4'h8 :
				   4'h0;
				   
	
	

	
	wire [4:0] RAddr1= ID_EX_Instr[25:21];//不需要在意Instr具体是什么指令，只要转发过来就行
	wire [4:0] RAddr2 = ID_EX_Instr[20:16];//因为如果是不相关的指令，转发过来也没用
							//这里要优先判断JAL和jalr，因为他们永远不需要转发
	assign ALUSrc_RData1 = RAddr1 == EX_MEM_WAddr && RAddr1 != 0 ? 4'b0001 :
						   RAddr1 == MEM_WB_WAddr && RAddr1 != 0 ? 4'b0010 :
						   4'b0000;
	assign ALUSrc_RData2 = RAddr2 == EX_MEM_WAddr && RAddr2 != 0 ? 4'b0001 :
						   RAddr2 == MEM_WB_WAddr && RAddr2 != 0 ? 4'b0010 : 
						   4'b0000;
	assign DMSrc = 		   RAddr2 == EX_MEM_WAddr && RAddr2 != 0 ? 4'b0001 :
						   RAddr2 == MEM_WB_WAddr && RAddr2 != 0 ? 4'b0010 : 
						   4'b0000;//DMSrc用这个信号
	///////////暂停、转发判断信号//////////////////////////////////////////////////////
	assign Tnew =	   Op == `ORI | Op == `ADDI | Op == `ADDIU | Op == `ANDI | Op == `XORI |
					   Op == `LUI | Op == `SLTI | Op == `SLTIU |
					   Op == `SH | Op == `SW |  Op == `SB |
					   Op == `CALCU & (Func == `ADDU_FUNC | Func == `SUBU_FUNC | Func == `ADD_FUNC |
					   Func == `SUB_FUNC | Func == `OR_FUNC | Func == `AND_FUNC | Func == `XOR_FUNC |
					   Func == `NOR_FUNC | Func == `SLLV_FUNC | Func == `SRLV_FUNC | Func == `SRAV_FUNC|
					   Func == `SLL_FUNC | Func == `SRL_FUNC | Func == `SRA_FUNC |
					   Func == `SLT_FUNC | Func == `SLTU_FUNC) ? 4'h1 : 
					   Op == `LB | Op == `LBU | Op ==`LH |
					   Op == `LHU | Op == `LW ? 4'h2 : 4'h0;
//////////////////处理乘除槽//////////////////////////////////////
	assign Install =Busy & Op == `CALCU & (Func == `MULT_FUNC | Func == `MULTU_FUNC |
					Func == `DIV_FUNC | Func == `DIVU_FUNC | Func == `MFHI_FUNC | Func == `MTHI_FUNC |
					Func == `MFLO_FUNC | Func == `MTLO_FUNC);		   
	
					   
	
endmodule
