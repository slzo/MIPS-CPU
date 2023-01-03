`timescale 1ns / 1ps

module ImmExt(
	input wire [15:0] imm16,
	input wire [25:0] imm26,
	input wire [4:0] imm5,
	input wire Lui,
	input wire J_imm26,
	input wire LeftEXT_imm5,
	
	input wire SLeftEXT_imm16,
	output reg [31:0] Out
    );
	always @(*) begin
		if(J_imm26) begin
			Out = {{6{1'b0}}, imm26[25:0]};
		end
		else if(Lui) begin
			Out = {imm16[15:0], {16{1'b0}}};
		end
		
		else if(SLeftEXT_imm16)begin
			
			if(imm16[15] == 1)
				Out = {{16{1'b1}}, imm16[15:0]};
			else
				Out = {{16{1'b0}}, imm16[15:0]};
		end
		
		else if(LeftEXT_imm5) begin
			Out = {{27{1'b0}}, imm5};
		end
		else begin
			Out = {{16{1'b0}}, imm16[15:0]};
		end
	end
endmodule
