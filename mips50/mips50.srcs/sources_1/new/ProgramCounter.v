`timescale 1ns / 1ps

module ProgramCounter(
    input clk,
    input reset,
    input En,
    input [31:0] NPC,
    output reg [31:0] PC
    );
	initial begin
		PC <= 32'h3000;
	end
	always @(posedge clk) begin
		if(reset) begin
			PC <= 32'h3000;
		end
		else begin
			if(En) begin
				PC <= NPC;
			end
		end
	end

endmodule
