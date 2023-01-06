`timescale 1ns / 1ps
//instr
`define ADDU  6'b100001
`define SUBU  6'b100011
`define ORI   6'b001101
`define LW    6'b100011
`define SW    6'b101011
`define BEQ   6'b000100
`define JAL   6'b000011
`define JR    6'b001000
`define LUI   6'b001111
`define LB    6'b100000
`define SB    6'b101000
`define LH    6'b100001
`define SH    6'b101001
`define RTYPE 6'b000000
`define J     6'b000010
`define ADDI  6'b001000
`define JALR  6'b001001
`define LBU	  6'b100100
`define LHU	  6'b100101
`define ADD	  6'b100000
`define SUB	  6'b100010
`define OR	  6'b100101
`define AND	  6'b100100
`define ANDI  6'b001100
`define XOR	  6'b100110
`define XORI  6'b001110
`define NOR	  6'b100111
`define ADDIU 6'b001001
`define SLL	  6'b000000
`define SLLV  6'b000100
`define SLT	  6'b101010
`define SLTI  6'b001010
`define SLTU  6'b101011
`define SLTIU 6'b001011
`define MULT  6'b011000
`define MULTU 6'b011001
`define DIV	  6'b011010
`define DIVU  6'b011011
`define SRL	  6'b000010
`define SRLV  6'b000110
`define SRA	  6'b000011
`define SRAV  6'b000111
`define BNE	  6'b000101
`define BLEZ  6'b000110
`define BGTZ  6'b000111
`define BLTZ  6'b000001
`define BGEZ  6'b000001
`define MFHI  6'b010000
`define MFLO  6'b010010
`define MTHI  6'b010001
`define MTLO  6'b010011

//ALUOp:
`define ALU_ADD   4'b0000
`define ALU_SUB   4'b0001
`define ALU_OR    4'b0010
`define ALU_SLL   4'b0011
`define ALU_SLT   4'b0100
`define ALU_SLTU  4'b0101
`define ALU_AND   4'b0110
`define ALU_NOR   4'b0111
`define ALU_XOR   4'b1000
`define ALU_SRA   4'b1001
`define ALU_SRL   4'b1010

//NPCOp:
`define NPC_PC4 3'b000
`define NPC_Br  3'b001
`define NPC_J   3'b010
`define NPC_JR  3'b011

//MDU:
`define MDU_MULT  3'b000
`define MDU_MULTU 3'b001
`define MDU_DIV   3'b010
`define MDU_DIVU  3'b011

//CMP:
`define CMP_BEQ  3'b000
`define CMP_BNE  3'b001
`define CMP_BLEZ 3'b010
`define CMP_BGTZ 3'b011
`define CMP_BLTZ 3'b100
`define CMP_BGEZ 3'b101
