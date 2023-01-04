`timescale 1ns / 1ps
module ProgramCounter(
    input wire [31:0] Addr,
	input wire clk,
	input wire reset,
	input wire enable,
	output reg [31:0] Out
    );
	always @(posedge clk) begin
		if(reset) begin
			Out <= 32'h00003000;
		end
		else if(enable) begin
			Out <= Addr;
		end
		else begin
			Out <= Out;
		end
	end	
endmodule
