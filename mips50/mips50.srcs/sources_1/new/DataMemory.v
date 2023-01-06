`timescale 1ns / 1ps
`include "Defines.v"

module DataMemory(
    input clk,
    input reset,
    input WE,
	input [31:0] PC,
    input [31:0] A,
    input [31:0] WD,
    output [31:0] RD,
    input [1:0] SSel
    );
	reg [31:0] datamemory[4095:0];
	integer i, file;
	reg [31:0] WData;
	wire [31:0] Addr;
	initial begin
	    file = $fopen("/home/soda/cpu/pipline/Mips50TestCodeAns/TestAns/myans.txt");
//	    file = 1;
		for(i=0;i<4096;i = i + 1) begin
			datamemory[i] = 32'h0;
		end
	end
	always @(*) begin
		if(SSel == 2'b00) begin
			WData = WD;
		end
		else if(SSel == 2'b01) begin
			WData = (A[1:0] == 2'b00) ? {datamemory[A[15:2]][31:8],WD[7:0]} :
						(A[1:0] == 2'b01) ? {datamemory[A[15:2]][31:16],WD[7:0],datamemory[A[15:2]][7:0]} :
						(A[1:0] == 2'b10) ? {datamemory[A[15:2]][31:24],WD[7:0],datamemory[A[15:2]][15:0]} :
														{WD[7:0],datamemory[A[15:2]][23:0]};
		end
		else if(SSel == 2'b10) begin
			WData = (A[1] == 1'b0) ? {datamemory[A[15:2]][31:16],WD[15:0]} : {WD[15:0],datamemory[A[15:2]][15:0]};
		end
	end
	assign Addr = {A[31:2],2'b00};
	always @(posedge clk) begin
		if(reset == 1) begin
			for(i=0;i<12287;i = i + 1) begin
				datamemory[i] <= 32'h0;
			end
		end
		else begin
			 if(WE == 1) begin
				datamemory[A[15:2]] <= WData;
				$fdisplay(file, "@%h: *%h <= %h",PC, Addr, WData);
			 end
		end
	end
	assign RD = datamemory[A[15:2]];
endmodule
