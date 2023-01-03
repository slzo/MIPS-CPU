`timescale 1ns / 1ps

module MemoryExt (
	input wire [31:0] Data,
	input wire LoadSigned,
	input wire [3:0] MemRead,
	output wire [31:0] Out
);
	assign Out = MemRead == 4'b0001 ? 
				 LoadSigned ? {{24{Data[7]}}, Data[7:0]} : {{24{1'b0}}, Data[7:0]} :
				 MemRead == 4'b0010 ? 
				 LoadSigned ? {{24{Data[15]}}, Data[15:8]} : {{24{1'b0}}, Data[23:16]} :
				 MemRead == 4'b0100 ? 
				 LoadSigned ? {{24{Data[23]}}, Data[23:16]} : {{24{1'b0}}, Data[15:8]} :
				 MemRead == 4'b1000 ? 
				 LoadSigned ? {{24{Data[31]}}, Data[31:24]} : {{24{1'b0}}, Data[31:24]} :
				 MemRead == 4'b0011 ? 
				 LoadSigned ? {{16{Data[15]}}, Data[15:0]} : {{16{1'b0}}, Data[15:0]} :
				 MemRead == 4'b1100 ? 
				 LoadSigned ? {{16{Data[31]}}, Data[31:16]} : {{24{1'b0}}, Data[31:16]} :
				 MemRead == 4'b1111 ? 
				 Data : Data;

endmodule
