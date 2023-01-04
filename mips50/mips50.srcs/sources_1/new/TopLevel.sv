`timescale 1ns / 1ps
`include "Define.v"
`include "MultiplicationDivisionUnit.sv"
module TopLevel(
	input wire clk,
    input wire reset
    );
	
	//Ԫ��������ӿ� 
	wire [31:0] PC_Out;
	wire [31:0] IM_Out;
	wire [31:0] Adder_Out, NAdder_Out;
	
	wire [31:0] GRF_RData1, GRF_RData2;
	wire [31:0] EXT_Out;
	wire [31:0] Shifter_Out;
	wire [31:0] CMPSrcMux_rs, CMPSrcMux_rt;
	wire [31:0] PCSrcMux_Out;
	
	wire [31:0] ALU_Out;
	wire ALU_Overflow;
	wire [31:0] ALUSrcMux_Out1, ALUSrcMux_Out2;
	wire [31:0] CMP_LessThan_Out;
	wire [31:0] MD_HI, MD_LO;
	wire [31:0] DMSrcMux_Out;
	wire [31:0] EX_ALUResultSrcMux_Out;
	
	wire [31:0] DM_Out;
	wire [31:0] MemEXT_Out;

	wire [31:0] regWriteMux_Out;
	
	wire [4:0] IF_ID_WAddr, ID_EX_WAddr, EX_MEM_WAddr, MEM_WB_WAddr;

//////////////////////��ˮ�Ĵ���������ӿ�///////////////////////////////////////
	
	
	wire [31:0] IF_ID_PC, IF_ID_Instr;
	
	wire [31:0] ID_EX_Instr, ID_EX_RData1, ID_EX_RData2;
	wire [31:0] ID_EX_PC, ID_EX_imm32;
	
	wire [31:0] EX_MEM_Instr, EX_MEM_ALUResult, EX_MEM_RData2, EX_MEM_PC;
	wire EX_MEM_Overflow;
	
	wire [31:0] MEM_WB_Instr, MEM_WB_Data, MEM_WB_ALUResult, MEM_WB_PC;
	wire MEM_WB_Overflow;
	
///////////////����ͨ·�����źŵĽӿ�//////////////////////////////////////////////
	
	wire Lui, SLeftEXT_imm16, LeftEXT_imm5, RsToPC, J_imm26;
	wire [3:0] Branch, CMPSrc_rs, CMPSrc_rt, PCSrc_RsToPC;
	wire Cmp;
	
	wire ALUSrc1, ALUSrc2, CalcuSigned;
	wire [2:0] MDOp;
	wire [3:0] ALUOp, EX_ALUResultSrc, ALUSrc_RData1, ALUSrc_RData2, DMSrc;
	wire Busy;

	wire LoadSigned;
	wire [3:0] MemWrite, MemRead;

	wire MemToReg, PCToReg, RegWrite;


	//��ͣ�����źŵ�����ӿ�
	wire IF_IDInstall, ID_EXInstall;
	wire PCEnable, IF_IDEnable, ID_EXEnable;
	wire ID_EXClear, EX_MEMClear;
	//������֮��ļĴ�����ַ��Tnew���ź�
	wire [3:0] ID_EX_Tnew, EX_MEM_Tnew, MEM_WB_Tnew;

	
	//==============IF��=========================================
	ProgramCounter PC(
		.Addr(PCSrcMux_Out),
		.clk(clk),
		.reset(reset),
		.enable(PCEnable),
		.Out(PC_Out)
	);
	
	InstructionMemory IM(
		.Addr(PC_Out[13:2]),
		.Out(IM_Out)
	);
	
	PCAdder PCA(
		.PC(PC_Out),
		.Out(Adder_Out)
	);
	//ע�⣡Ҫʹ��NAdder��Զ��ID��ʹ�ã�ʹ�õ�����һ��PC��Adder����һ��PC��������
	NAdder NAdder(
		.Shifter(Shifter_Out),
		.PC(IF_ID_PC),
		.Out(NAdder_Out)
	);
	
	IF_ID IFID(
		.PC(PC_Out),
		.Instr(IM_Out),
		.clk(clk),
		.reset(reset),
		.enable(IF_IDEnable),
		.Out_PC(IF_ID_PC),
		.Out_Instr(IF_ID_Instr)
	);
	//==============ID��=========================================

	GeneralRegisters GR(
		.PC(MEM_WB_PC),
		.R1(IF_ID_Instr[25:21]),
		.R2(IF_ID_Instr[20:16]),
		.WReg(MEM_WB_WAddr),
		.Data(regWriteMux_Out),
		.clk(clk),
		.reset(reset),
		.RegWrite(RegWrite),
		.RData1(GRF_RData1),
		.RData2(GRF_RData2)
	);
	ImmExt EXT(
		.imm16(IF_ID_Instr[16:0]),
		.imm26(IF_ID_Instr[26:0]),
		.imm5(IF_ID_Instr[10:6]),
		.Lui(Lui),
		.J_imm26(J_imm26),
		.SLeftEXT_imm16(SLeftEXT_imm16),
		.LeftEXT_imm5(LeftEXT_imm5),
		.Out(EXT_Out)
	);
	Shifter Shifter(
		.EXT(EXT_Out),
		.Out(Shifter_Out)
	);
	
	Comparator CMP(
		.RData1(CMPSrcMux_rs),
		.RData2(CMPSrcMux_rt),
		.Branch(Branch),
		.Cmp(Cmp)
	);
	CMPSrcMux CSM(
		.RData1(GRF_RData1),
		.RData2(GRF_RData2),
		.ID_EX_PC(ID_EX_PC),
		.EX_MEM_ALUResult(EX_MEM_ALUResult),
		.MEM_WB_regWriteMux(regWriteMux_Out),
		.CMPSrc_rs(CMPSrc_rs),
		.CMPSrc_rt(CMPSrc_rt),
		.Out_rs(CMPSrcMux_rs),
		.Out_rt(CMPSrcMux_rt)
	);
	
	PCSrcMux PSM(
		.Cmp(Cmp),
		.RsToPC(RsToPC),
		.J_imm26(J_imm26),
		.Adder(Adder_Out),
		.NAdder(NAdder_Out),
		.Shifter(Shifter_Out),
		.RData1(GRF_RData1),
		.PCSrc_RsToPC(PCSrc_RsToPC),
		.ID_EX_PC(ID_EX_PC),
		.EX_MEM_ALUResult(EX_MEM_ALUResult),
		.MEM_WB_regWriteMux(regWriteMux_Out),
		.Out(PCSrcMux_Out)
	);
	
	ID_EX IDEX(
		.RData1(GRF_RData1),
		.RData2(GRF_RData2),
		.PC(IF_ID_PC),
		.imm32(EXT_Out),
		.clk(clk),
		.reset(reset),
		.clear(ID_EXClear),
		.enable(ID_EXEnable),
		.Instr(IF_ID_Instr),
		.WAddr(IF_ID_WAddr),
		.Out_WAddr(ID_EX_WAddr),
		.Out_Instr(ID_EX_Instr),
		.Out_RData1(ID_EX_RData1),
		.Out_RData2(ID_EX_RData2),
		.Out_PC(ID_EX_PC),
		.Out_imm32(ID_EX_imm32)
	);
	
	
	//==============EX��=========================================
	ALU ALU(
		.RData1(ALUSrcMux_Out1),
		.RData2(ALUSrcMux_Out2),
		.ALUOp(ALUOp),
		.CalcuSigned(CalcuSigned),
		.Overflow(ALU_Overflow),
		.Out(ALU_Out)
	);
	ALUSrcMux ASM(
		.RData1(ID_EX_RData1),
		.RData2(ID_EX_RData2),
		.imm32(ID_EX_imm32),
		.ALUSrc1(ALUSrc1),
		.ALUSrc2(ALUSrc2),
		.ALUSrc_RData1(ALUSrc_RData1),
		.ALUSrc_RData2(ALUSrc_RData2),
		.EX_MEM_ALUResult(EX_MEM_ALUResult),
		.MEM_WB_regWriteMux(regWriteMux_Out),
		.Out1(ALUSrcMux_Out1),
		.Out2(ALUSrcMux_Out2)
	);
	CMP_LessThan CLT(
		.RData1(ALUSrcMux_Out1),
		.RData2(ALUSrcMux_Out2),
		.CalcuSigned(CalcuSigned),
		.Out(CMP_LessThan_Out)
	);
	wire start;
	wire [31:0] mddatare;
//    mdu_operation_t mdop = mdu_operation_t'(MDOp);
	MultiplicationDivisionUnit MD(
		.operand1(ALUSrcMux_Out1),
		.operand2(ALUSrcMux_Out2),
		.operation(mdu_operation_t'(MDOp)),
		.clock(clk),
		.reset(reset),
		.start(start),
		.busy(Busy),
		.dataRead(mddatare)
	);
//	MDReDesMUX MDR(
//		.dessrc(MDOp),
//		.data(mddatare),
//		.HI(MD_HI),
//		.LO(MD_LO)
//	);
    assign MD_HI = MDOp==3'b000 ? mddatare: MD_HI;
	assign MD_LO = MDOp==3'b001 ? mddatare: MD_LO;
	DMSrcMux DSM(
		.ID_EX_RData2(ID_EX_RData2),
		.EX_MEM_ALUResult(EX_MEM_ALUResult),
		.MEM_WB_regWriteMux(regWriteMux_Out),
		.DMSrc(DMSrc),
		.Out(DMSrcMux_Out)
	);
	EX_ALUResultSrcMux EARSM(
		.ALUResult(ALU_Out),
		.LT(CMP_LessThan_Out),
		.ID_EX_PC(ID_EX_PC),
		.HI(MD_HI),
		.LO(MD_LO),
		.EX_ALUResultSrc(EX_ALUResultSrc),
		.Out(EX_ALUResultSrcMux_Out)
	);
	EX_MEM EXMEM(
		.ALUResult(EX_ALUResultSrcMux_Out),
		.RData2(DMSrcMux_Out),
		.PC(ID_EX_PC),
		.clk(clk),
		.reset(reset),
		.clear(EX_MEMClear),
		.Instr(ID_EX_Instr),
		.Overflow(ALU_Overflow),
		.WAddr(ID_EX_WAddr),
		.Out_Overflow(EX_MEM_Overflow),
		.Out_WAddr(EX_MEM_WAddr),
		.Out_Instr(EX_MEM_Instr),
		.Out_ALUResult(EX_MEM_ALUResult),
		.Out_RData2(EX_MEM_RData2),
		.Out_PC(EX_MEM_PC)
	);
//==============MEM��=========================================

	DataMemory DM(
		.PC(EX_MEM_PC),
		.Addr(EX_MEM_ALUResult[15:2]),
		.Data(EX_MEM_RData2),
		.clk(clk),
		.reset(reset),
		.MemWrite(MemWrite),
		.Out(DM_Out)
	);
	MemoryExt MemEXT(
		.Data(DM_Out),
		.LoadSigned(LoadSigned),
		.MemRead(MemRead),
		.Out(MemEXT_Out)
	);
	
	MEM_WB MEMWB(
		.Data(MemEXT_Out),
		.ALUResult(EX_MEM_ALUResult),
		.PC(EX_MEM_PC),
		.clk(clk),
		.reset(reset),
		.Instr(EX_MEM_Instr),
		.Overflow(EX_MEM_Overflow),
		.WAddr(EX_MEM_WAddr),
		.Out_WAddr(MEM_WB_WAddr),
		.Out_Overflow(MEM_WB_Overflow),
		.Out_Instr(MEM_WB_Instr),
		.Out_Data(MEM_WB_Data),
		.Out_ALUResult(MEM_WB_ALUResult),
		.Out_PC(MEM_WB_PC)
	);
	regWriteMux RWM(
		.PC(MEM_WB_PC),
		.ALUResult(MEM_WB_ALUResult),
		.Data(MEM_WB_Data),
		.PCToReg(PCToReg),
		.MemToReg(MemToReg),
		.Out(regWriteMux_Out)
	);
//==============WB�κ�ID�κ϶�Ϊһ��=========================================
//==============Controller��=========================================
	
	InstallCU ICU(
		.IF_IDInstall(IF_IDInstall),
		.ID_EXInstall(ID_EXInstall),
		.PCEnable(PCEnable),
		.IF_IDEnable(IF_IDEnable),
		.ID_EXEnable(ID_EXEnable),
		.ID_EXClear(ID_EXClear),
		.EX_MEMClear(EX_MEMClear)
	);
	IF_ID_CU IFIDCU(
		.IF_ID_Instr(IF_ID_Instr),
		.ID_EX_WAddr(ID_EX_WAddr),
		.EX_MEM_WAddr(EX_MEM_WAddr),
		.MEM_WB_WAddr(MEM_WB_WAddr),
		.ID_EX_Tnew(ID_EX_Tnew),
		.EX_MEM_Tnew(EX_MEM_Tnew),
		.MEM_WB_Tnew(MEM_WB_Tnew),
		
		.Lui(Lui),
		.SLeftEXT_imm16(SLeftEXT_imm16),
		.LeftEXT_imm5(LeftEXT_imm5),
		.Branch(Branch),
		.RsToPC(RsToPC),
		.J_imm26(J_imm26),
		
		.CMPSrc_rs(CMPSrc_rs),
		.CMPSrc_rt(CMPSrc_rt),
		.PCSrc_RsToPC(PCSrc_RsToPC),
		
		.Install(IF_IDInstall),
		.WAddr(IF_ID_WAddr)
	);
	
	ID_EX_CU IDEXCU(
		.ID_EX_Instr(ID_EX_Instr),
		.EX_MEM_WAddr(EX_MEM_WAddr),
		.MEM_WB_WAddr(MEM_WB_WAddr),
		
		.Busy(Busy),

		.ALUOp(ALUOp),
		.ALUSrc1(ALUSrc1),
		.ALUSrc2(ALUSrc2),
		.CalcuSigned(CalcuSigned),
		.MDOp(MDOp),
		.EX_ALUResultSrc(EX_ALUResultSrc),
		.ALUSrc_RData1(ALUSrc_RData1),
		.ALUSrc_RData2(ALUSrc_RData2),
		.DMSrc(DMSrc),
		.Tnew(ID_EX_Tnew),
		.Install(ID_EXInstall),
		.start(start)
	);
	
	EX_MEM_CU EXMEMCU(
		.EX_MEM_Instr(EX_MEM_Instr),
		.MEM_WB_WAddr(MEM_WB_WAddr),
		.ALULast(EX_MEM_ALUResult[1:0]),
		
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.LoadSigned(LoadSigned),
		
		.Tnew(EX_MEM_Tnew)
	);
	
	MEM_WB_CU MEMWBCU(
		.MEM_WB_Instr(MEM_WB_Instr),
		.Overflow(MEM_WB_Overflow),
		.PCToReg(PCToReg),
		.MemToReg(MemToReg),
		.RegWrite(RegWrite),
		.Tnew(MEM_WB_Tnew)
	);
	
	
endmodule
