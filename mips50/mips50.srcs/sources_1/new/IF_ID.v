`timescale 1ns / 1ps

module IF_ID( input wire[31:0] IF_ID_INS,
              input wire [4:0] ID_EX_REG, EX_MEM_REG, MEM_WB_REG,
              input wire [3:0] ID_EX_T, EX_MEM_T, MEM_WB_T,
              
              output wire lui, slimm16, limm5,
              output wire [2:0] branch,
              output wire R2P, jimm26,
              output wire [1:0] rs, rt, rs2pc,
              output wire STOP,
              output wire [4:0] writeaddress );
              
  wire [31:0] instruction = IF_ID_INS[31:0];
  wire [5:0] op = IF_ID_INS[31:26];
  wire [5:0] func = IF_ID_INS[5:0];
  assign branch = 3'b0;
  assign branch = (op==`BEQ)?3'b001:branch;
  assign branch = (op==`BNE)?3'b010:branch;
  assign branch = (op==`BLTZ & instruction[20:16]!=5'b000001)?3'b011:branch;
  assign branch = (op==`BLEZ)?3'b100:branch;
  assign branch = (op==`BEQ)?3'b101:branch;
  assign branch = (op==`BEQ)?3'b110:branch;
  assign slimm16 = op==`BEQ | op==`BNE | op==`BLTZ | op==`BLEZ | op == `BGTZ | op == `BGEZ |
				   op==`ADDI | op==`ADDIU | op==`SLTI | op==`SLTIU |
                   op==`LB | op==`LBU | op==`LH | op==`LHU | op==`LW | 
                   op==`SB | op==`SH | op==`SW;
  assign lui = op==`LUI;
  assign R2P = op==`CALCU & (func==`JR | func==`JALR);
  assign jimm26 = op==`J | op==`JAL;
  assign limm5 = op==`CALCU & (func==`SLL | func==`SRL | func==`SRA);
  
  wire [4:0] opd1 = op==`BEQ | op==`BNE | op==`BLEZ | op==`BGTZ | op==`BLTZ | op==`BGEZ |
                    op==`CALCU & (func==`JR | func==`JALR | 
                                  func == `ADDU | func==`SUBU | func==`ADD | func==`SUB | 
                                  func==`OR | func==`AND | func==`XOR | func==`NOR | 
                                  func==`SLLV | func==`SRLV | func==`SRAV | func==`SLL | func==`SRL | func==`SRA | func==`SLT | func==`SLTU) |
                    op==`ORI | op==`ADDI | op==`ADDIU | op==`ANDI | op==`XORI |
                    op==`LUI | op==`SLTI | op==`SLTIU |
                    op==`LB | op==`LBU | op==`LH | op==`LHU | op==`LW | 
                    op==`SB | op==`SH | op==`SW  ? instruction[25:21] : 5'b00000;
                    
  wire [4:0] opd2 = op==`BEQ | op==`BNE | op==`BLEZ | op==`BGTZ |
					op==`CALCU & (func==`ADDU | func==`SUBU | func==`ADD | func==`SUB | 
					              func==`OR | func==`AND | func==`XOR | func == `NOR | 
					              func==`SLLV | func==`SRLV | func==`SRAV | func == `SLT | func == `SLTU | func == `SLL | func == `SRL | func == `SRA) |
					op==`SB | op==`SH | op==`SW ? instruction[20:16] : 5'b00000;
  assign rs = opd1==EX_MEM_REG && opd1!=0 ? 4'b01 : 
              opd1==MEM_WB_REG && opd1!=0 ? 4'b10 :
              opd1==ID_EX_REG  && opd1!=0 ? 4'b11 : 2'b00;
  assign rt = opd1==EX_MEM_REG && opd2!=0 ? 4'b01 : 
              opd1==MEM_WB_REG && opd2!=0 ? 4'b10 :
              opd1==ID_EX_REG  && opd2!=0 ? 4'b11 : 2'b00;
  assign rs2pc = rs;
  assign writeaddress = op==`CALCU & (func==`ADDU | func==`SUBU | func==`ADD | func == `SUB | 
                                      func == `OR | func == `AND | func == `XOR | func == `NOR | 
                                      func == `SLLV | func == `SRLV | func == `SRAV| func == `SLL | func == `SRL | func == `SRA | func == `SLT | func == `SLTU |
                                      func==`JALR | func==`MFHI | func==`MFLO) ? instruction[15:11] :
					    op==`ORI | op==`ADDI | op==`ADDIU | op==`ANDI | op==`XORI |
					    op==`LUI | op==`SLTI | op==`SLTIU | op==`LB | op==`LBU |
					    op==`LH | op==`LHU | op==`LW ? instruction[20:16] :
					    op==`JAL ? 5'b11111 : 5'b00000;
  	wire [3:0] Tuse1 = op == `BEQ | op == `BNE | op == `BLEZ | op == `BGTZ |
					   op == `BLTZ | op == `BGEZ |
					   op == `CALCU & (func == `JR | func == `JALR) ? 0 :
					   op == `ORI | op == `ADDI | op == `ADDIU | op == `ANDI | op == `XORI |
					   op == `LUI | op == `SLTI | op == `SLTIU |
					   op == `LB | op == `LBU | op ==`LH |
					   op == `LHU | op == `LW | op == `SB |
					   op == `SH | op == `SW |
					   op == `CALCU & (func == `ADDU | func == `SUBU | func == `ADD |
					   func == `SUB | func == `OR | func == `AND | func == `XOR |
					   func == `NOR | func == `SLLV | func == `SRLV | func == `SRAV|
					   func == `SLL | func == `SRL | func == `SRA |
					   func == `SLT | func == `SLTU) ? 1 : 4'b0111;
	wire [3:0] Tuse2 = op == `BEQ | op == `BNE | op == `BLEZ | op == `BGTZ ? 0 :
					   op == `CALCU & (func == `ADDU | func == `SUBU | func == `ADD |
					   func == `SUB | func == `OR | func == `AND | func == `XOR |
					   func == `NOR | func == `SLLV | func == `SRLV | func == `SRAV|
					   func == `SLT | func == `SLTU | func == `SLL | func == `SRL | 
					   func == `SRA) |
					   op == `SB | op == `SH | op == `SW ? 1 : 4'b0111; 
    assign STOP = opd1 == ID_EX_REG  & opd1 != 0 & Tuse1 < ID_EX_T |
                  opd1 == EX_MEM_REG & opd1 != 0 & Tuse1 < EX_MEM_T |
                  opd1 == MEM_WB_REG & opd1 != 0 & Tuse1 < MEM_WB_T |
                  opd2 == ID_EX_REG  & opd2 != 0 & Tuse2 < ID_EX_T |
                  opd2 == EX_MEM_REG & opd2 != 0 & Tuse2 < EX_MEM_T |
                  opd2 == MEM_WB_REG & opd2 != 0 & Tuse2 < MEM_WB_T;
endmodule
