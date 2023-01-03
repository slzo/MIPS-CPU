`timescale 1ns / 1ps

module DataMemory(
	input wire [31:0] PC,
    input wire [15:2] Addr,
    input wire [31:0] Data,
    input wire reset,
	input wire clk,
    input wire [3:0] MemWrite,
    output reg [31:0] Out
    );
	reg [31:0] datamemory [0:2047];
	integer i;
	
	always @(posedge clk) begin
		if(reset) begin
			for(i = 0; i < 2048; i = i + 1)
				datamemory[i] <= 32'h00000000;
		end
		else begin
			if(MemWrite == 4'b0001) begin
				datamemory[Addr][7:0] <= Data[7:0];
				$display("@%h: *%h <= %h", PC, {{16{1'b0}}, Addr[15:2], {2{1'b0}}}, {datamemory[Addr][31:8], Data[7:0]});
			end
			else if(MemWrite == 4'b0010) begin
				datamemory[Addr][15:8] <= Data[7:0];
				$display("@%h: *%h <= %h", PC, {{16{1'b0}}, Addr[15:2], {2{1'b0}}}, {datamemory[Addr][31:16], Data[7:0], datamemory[Addr][7:0]});
			end
			else if(MemWrite == 4'b0100) begin
				datamemory[Addr][23:16] <= Data[7:0];
				$display("@%h: *%h <= %h", PC, {{16{1'b0}}, Addr[15:2], {2{1'b0}}}, {datamemory[Addr][31:24], Data[7:0], datamemory[Addr][15:0]});
			end
			else if(MemWrite == 4'b1000) begin
				datamemory[Addr][31:24] <= Data[7:0];
				$display("@%h: *%h <= %h", PC, {{16{1'b0}}, Addr[15:2], {2{1'b0}}}, {Data[7:0], datamemory[Addr][23:0]});
			end
			else if(MemWrite == 4'b0011) begin
				datamemory[Addr][15:0] <= Data[15:0];
				$display("@%h: *%h <= %h", PC, {{16{1'b0}}, Addr[15:2], {2{1'b0}}}, {datamemory[Addr][31:16], Data[15:0]});
			end
			else if(MemWrite == 4'b1100) begin
				datamemory[Addr][31:16] <= Data[15:0];
				$display("@%h: *%h <= %h", PC, {{16{1'b0}}, Addr[15:2], {2{1'b0}}}, {Data[15:0], datamemory[Addr][15:0]});
			end
			else if(MemWrite == 4'b1111) begin
				datamemory[Addr] <= Data;
				$display("@%h: *%h <= %h", PC, {{16{1'b0}}, Addr[15:2], {2{1'b0}}}, Data);
			end
			else begin
			end
		end
	end
	always @(*) begin
		Out <= datamemory[Addr];
	end
	
endmodule
