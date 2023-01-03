`timescale 1ns / 1ps
`include "Define.v"

module MultiplicationDivisionUnit(
	input wire [31:0] RData1,
	input wire [31:0] RData2,
	input wire [1:0] MDOp,
	input wire [1:0] MDWrite,
	input wire CalcuSigned,
	input wire clk,
	input wire reset,
	output reg Busy,
	output reg [31:0] HI,
	output reg [31:0] LO
    );
	reg [3:0] count;
	reg calcuType;
	reg [63:0] result;
	
	initial begin
		Busy = 1'b0;
		HI = 0;
		LO = 0;
		count = 4'h0;
		calcuType = 1'b0;
	end
	
	always @(posedge clk) begin
		if(reset == 1) begin
			Busy <= 1'b0;
			HI <= 0;
			LO <= 0;
			count <= 4'h0;
			calcuType <= 1'b0;
		end
		else begin
			if(Busy == 1) begin
				if(~calcuType & count == 4'h6 | calcuType & count == 4'hb) begin
					HI <= result[63:32];
					LO <= result[31:0];
					count <= 0;
					Busy <= 0;
				end
				else begin
					count <= count + 1;
					Busy <= 1;
				end
			end
			else if(MDOp == 2'b01) begin
				if(CalcuSigned) begin
					result <= $signed(RData1) * $signed(RData2);
				end
				else begin
					result <= RData1 * RData2;
				end
				calcuType <= 0;
				count <= 1;
				Busy <= 1;
			end
			else if(MDOp == 2'b10) begin
				// result前32位存除数，后32位存余数
				if(CalcuSigned) begin
					result[63:32] <= $signed(RData1) % $signed(RData2);
					result[31:0] <= $signed(RData1) / $signed(RData2);
				end
				else begin
					result[63:32] <= RData1 % RData2;
					result[31:0] <= RData1 / RData2;
				end
				calcuType <= 1;
				count <= 1;
				Busy <= 1;
			end
			else if(MDWrite == 2'b01) begin
				HI <= RData1;
			end
			else if(MDWrite == 2'b10) begin
				LO <= RData1;
			end
			else begin
				//Do nothing.
				Busy <= 0;
			end
		end
	end
	


endmodule
