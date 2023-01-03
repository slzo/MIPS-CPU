`timescale 1ns / 1ps

module GeneralRegisters(
	input wire [31:0] PC,
	input wire [4:0] R1,
	input wire [4:0] R2,
	input wire [4:0] WReg,
	input wire [31:0] Data,
	input wire clk,
	input wire reset,
	input wire RegWrite,
	output reg [31:0] RData1,
	output reg [31:0] RData2
    );
	reg [31:0] registers[0:31];
	integer i;

	always @(posedge clk) begin
		if(reset == 1) begin
			for(i = 0; i < 32; i = i + 1) begin
				registers[i] <= 32'h00000000;
			end
		end
		else if(RegWrite == 1) begin
			$display("@%h: $%d <= %h", PC, WReg, Data);
			if(WReg != 0)
				registers[WReg] <= Data;
		end
		else begin
		end
	end
	
	always @(*) begin
//这里做的相当于是转发，相当于EX/WB寄存器向ID阶段转发
//然而实际上ID阶段不会"使用"寄存器的值。如果严格按照统一的做法，应该将GRF看作
//WB寄存器，然后增加WB寄存器到EX、MEM的转发。将GRF做成这种类型并且将DM的输入选择提前到EX阶段，
//可以避免上述的两条转发通路
		if(R1 == WReg & R1 != 0)
			RData1 = Data;
		else
			RData1 = registers[R1];
		if(R2 == WReg & R2 != 0)
			RData2 = Data;
		else
			RData2 = registers[R2];
	end

endmodule
