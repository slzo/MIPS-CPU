`timescale 1ns / 1ps
`include "Define.v"

module IF_ID_CU(
	input wire [31:0] IF_ID_Instr,

	//输入转发和暂停的信号
	input wire [4:0] ID_EX_WAddr,
	input wire [4:0] EX_MEM_WAddr,//the write-register's address
	input wire [4:0] MEM_WB_WAddr,
	input wire [3:0] ID_EX_Tnew,
	input wire [3:0] EX_MEM_Tnew,
	input wire [3:0] MEM_WB_Tnew,
	
	output wire Lui,
	output wire SLeftEXT_imm16,
	output wire LeftEXT_imm5,
	
	output wire [3:0] Branch,
	// 这两个和Branch控制PCSrcMux
	output wire RsToPC,
	output wire J_imm26,
	//这三个是转发控制信号
	output wire [3:0] CMPSrc_rs,
	output wire [3:0] CMPSrc_rt,
	output wire [3:0] PCSrc_RsToPC,
	
	
	//这是暂停信号
	output wire Install,
	
	output wire [4:0] WAddr
    );
	//处理数据通路信号
	wire [31:0] Instr = IF_ID_Instr[31:0];
	wire [5:0] Op = IF_ID_Instr[31:26];
	wire [5:0] Func = IF_ID_Instr[5:0];
	

	assign Branch = Op == `BEQ ? 4'b0001 :
					Op == `BNE ? 4'b0010 :
					Op == `BLTZ & Instr[20:16] != `BGEZ_RT ? 4'b0011 :
					Op == `BLEZ ? 4'b0100 :
					Op == `BGTZ ? 4'b0101 :
					Op == `BGEZ ? 4'b0110 :
					4'b0000;
	assign SLeftEXT_imm16 = Op == `BEQ | Op == `BNE | Op == `BLTZ |
							Op == `BLEZ | Op == `BGTZ | Op == `BGEZ |
							Op == `ADDI | Op == `ADDIU | Op == `SLTI | Op == `SLTIU |
							Op == `LB | Op == `LBU | Op ==`LH | 
							Op == `LHU | Op == `LW | Op == `SB |
							Op == `SH | Op == `SW;
	assign Lui = Op == `LUI;
	assign RsToPC = Op == `CALCU & (Func == `JR_FUNC | Func == `JALR_FUNC);
	assign J_imm26 = Op == `J | Op == `JAL;
	assign LeftEXT_imm5 = Op == `CALCU & (Func == `SLL_FUNC | Func == `SRL_FUNC |
						  Func == `SRA_FUNC);
	
	

	//处理转发信号
	//RAddr1是要使用的第一个寄存器地址。理论上对不通过的指令地址不同，但是这里均为rs
	//这里没有直接赋值为rs/rt的原因是，处理暂停信号时依然需要使用RAddr
	wire [4:0] RAddr1 =Op == `BEQ | Op == `BNE | Op == `BLEZ | Op == `BGTZ |
					   Op == `BLTZ | Op == `BGEZ |
					   Op == `CALCU & (Func == `JR_FUNC | Func == `JALR_FUNC) |
					   Op == `ORI | Op == `ADDI | Op == `ADDIU | Op == `ANDI | Op == `XORI |
					   Op == `LUI | Op == `SLTI | Op == `SLTIU |
					   Op == `LB | Op == `LBU | Op ==`LH |
					   Op == `LHU | Op == `LW | Op == `SB |
					   Op == `SH | Op == `SW |
					   Op == `CALCU & (Func == `ADDU_FUNC | Func == `SUBU_FUNC | Func == `ADD_FUNC |
					   Func == `SUB_FUNC | Func == `OR_FUNC | Func == `AND_FUNC | Func == `XOR_FUNC |
					   Func == `NOR_FUNC | Func == `SLLV_FUNC | Func == `SRLV_FUNC | Func == `SRAV_FUNC|
					   Func == `SLL_FUNC | Func == `SRL_FUNC | Func == `SRA_FUNC |
					   Func == `SLT_FUNC | Func == `SLTU_FUNC) ? Instr[25:21] : 5'b00000;
	wire [4:0] RAddr2 =Op == `BEQ | Op == `BNE | Op == `BLEZ | Op == `BGTZ |
					   Op == `CALCU & (Func == `ADDU_FUNC | Func == `SUBU_FUNC | Func == `ADD_FUNC |
					   Func == `SUB_FUNC | Func == `OR_FUNC | Func == `AND_FUNC | Func == `XOR_FUNC |
					   Func == `NOR_FUNC | Func == `SLLV_FUNC | Func == `SRLV_FUNC | Func == `SRAV_FUNC|
					   Func == `SLT_FUNC | Func == `SLTU_FUNC | Func == `SLL_FUNC | Func == `SRL_FUNC | 
					   Func == `SRA_FUNC) |
					   Op == `SB | Op == `SH | Op == `SW ? Instr[20:16] : 5'b00000;
	
	assign CMPSrc_rs = RAddr1 == EX_MEM_WAddr && RAddr1 != 0 ? 4'b0001 : 
					   RAddr1 == MEM_WB_WAddr && RAddr1 != 0 ? 4'b0010 :
					   RAddr1 == ID_EX_WAddr && RAddr1 != 0 ? 4'b0011 :
					   4'b0000;
	assign PCSrc_RsToPC = CMPSrc_rs;
	assign CMPSrc_rt = RAddr2 == EX_MEM_WAddr && RAddr2 != 0 ? 4'b0001 : 
					   RAddr2 == MEM_WB_WAddr && RAddr2 != 0 ? 4'b0010 :
					   RAddr2 == ID_EX_WAddr && RAddr2 != 0 ? 4'b0011 :
					   4'b0000;
	//////////////////解析出写入信号，依次往下传///////////////
	assign WAddr = 	   Op == `CALCU & (Func == `ADDU_FUNC | Func == `SUBU_FUNC | Func == `ADD_FUNC |
					   Func == `SUB_FUNC | Func == `OR_FUNC | Func == `AND_FUNC | Func == `XOR_FUNC |
					   Func == `NOR_FUNC | Func == `SLLV_FUNC | Func == `SRLV_FUNC | Func == `SRAV_FUNC|
					   Func == `SLL_FUNC | Func == `SRL_FUNC | Func == `SRA_FUNC |
					   Func == `SLT_FUNC | Func == `SLTU_FUNC |
					   Func == `JALR_FUNC | Func == `MFHI_FUNC | Func == `MFLO_FUNC) ? Instr[15:11] :
					   Op == `ORI | Op == `ADDI | Op == `ADDIU | Op == `ANDI | Op == `XORI |
					   Op == `LUI | Op == `SLTI | Op == `SLTIU | Op == `LB | Op == `LBU |
					   Op ==`LH | Op == `LHU | Op == `LW ? Instr[20:16] :
					   Op == `JAL ? 5'b11111 : 5'b00000;
	
	
	
	//处理暂停信号
	wire [3:0] Tuse1 = Op == `BEQ | Op == `BNE | Op == `BLEZ | Op == `BGTZ |
					   Op == `BLTZ | Op == `BGEZ |
					   Op == `CALCU & (Func == `JR_FUNC | Func == `JALR_FUNC) ? 0 :
					   Op == `ORI | Op == `ADDI | Op == `ADDIU | Op == `ANDI | Op == `XORI |
					   Op == `LUI | Op == `SLTI | Op == `SLTIU |
					   Op == `LB | Op == `LBU | Op ==`LH |
					   Op == `LHU | Op == `LW | Op == `SB |
					   Op == `SH | Op == `SW |
					   Op == `CALCU & (Func == `ADDU_FUNC | Func == `SUBU_FUNC | Func == `ADD_FUNC |
					   Func == `SUB_FUNC | Func == `OR_FUNC | Func == `AND_FUNC | Func == `XOR_FUNC |
					   Func == `NOR_FUNC | Func == `SLLV_FUNC | Func == `SRLV_FUNC | Func == `SRAV_FUNC|
					   Func == `SLL_FUNC | Func == `SRL_FUNC | Func == `SRA_FUNC |
					   Func == `SLT_FUNC | Func == `SLTU_FUNC) ? 1 : 
					   4'b0111;
	wire [3:0] Tuse2 = Op == `BEQ | Op == `BNE | Op == `BLEZ | Op == `BGTZ ? 0 :
					   Op == `CALCU & (Func == `ADDU_FUNC | Func == `SUBU_FUNC | Func == `ADD_FUNC |
					   Func == `SUB_FUNC | Func == `OR_FUNC | Func == `AND_FUNC | Func == `XOR_FUNC |
					   Func == `NOR_FUNC | Func == `SLLV_FUNC | Func == `SRLV_FUNC | Func == `SRAV_FUNC|
					   Func == `SLT_FUNC | Func == `SLTU_FUNC | Func == `SLL_FUNC | Func == `SRL_FUNC | 
					   Func == `SRA_FUNC) |
					   Op == `SB | Op == `SH | Op == `SW ? 1 : 4'b0111;
	
	assign Install =RAddr1 == ID_EX_WAddr & RAddr1 != 0 & Tuse1 < ID_EX_Tnew |
					RAddr1 == EX_MEM_WAddr & RAddr1 != 0 & Tuse1 < EX_MEM_Tnew |
					RAddr1 == MEM_WB_WAddr & RAddr1 != 0 & Tuse1 < MEM_WB_Tnew |
					RAddr2 == ID_EX_WAddr & RAddr2 != 0 & Tuse2 < ID_EX_Tnew |
					RAddr2 == EX_MEM_WAddr & RAddr2 != 0 & Tuse2 < EX_MEM_Tnew |
					RAddr2 == MEM_WB_WAddr & RAddr2 != 0 & Tuse2 < MEM_WB_Tnew;


endmodule
