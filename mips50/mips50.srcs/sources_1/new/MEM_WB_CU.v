`timescale 1ns / 1ps
`include "Define.v"

module MEM_WB_CU(
	input wire [31:0] MEM_WB_Instr,
	input wire Overflow,
	output wire PCToReg,
	output wire MemToReg,
	output wire RegWrite,
	output wire [3:0] Tnew
    );
	wire [5:0] Op = MEM_WB_Instr[31:26];
	wire [5:0] Func = MEM_WB_Instr[5:0];
	
	assign RegWrite = ((((Op == `CALCU & (Func == `ADD_FUNC | Func == `SUB_FUNC)) |Op == `ADDI) & Overflow == 0) |
					  ( Op == `CALCU & (Func == `ADDU_FUNC | Func == `SUBU_FUNC |  Func == `OR_FUNC |
                                      Func == `AND_FUNC | Func == `XOR_FUNC | Func == `NOR_FUNC |
                                      Func == `SLLV_FUNC | Func == `SRLV_FUNC | Func == `SRAV_FUNC |
                                      Func == `SLL_FUNC |Func == `SRL_FUNC | Func == `SRA_FUNC |
                                      Func == `SLT_FUNC | Func == `SLTU_FUNC | Func == `JALR_FUNC |
					                  Func == `MFHI_FUNC | Func == `MFLO_FUNC) ) |  
					  Op == `ORI | Op == `LUI |
					  Op == `ADDIU | Op == `ANDI | Op == `XORI |
					  Op == `SLTI | Op == `SLTIU |
					  Op == `LB | Op == `LBU | Op == `LH |
					  Op == `LHU | Op == `LW |
					  Op == `JAL)&(MEM_WB_Instr!=32'h0);
	assign PCToReg = Op == `JAL | (Op == `CALCU & Func == `JALR_FUNC);

	assign MemToReg = Op == `LB | Op == `LBU | Op == `LH |
					  Op == `LHU | Op == `LW;
	
	//处理暂停、转发信号
	assign Tnew = 0;
	
	// syscall
	always@(*)begin
        if(Op==6'b000000 && Func==6'b001100)
           $finish;
	end


endmodule
