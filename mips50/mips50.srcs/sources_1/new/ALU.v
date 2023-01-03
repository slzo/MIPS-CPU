`timescale 1ns / 1ps

module ALU(
    input wire [31:0] RData1,
    input wire [31:0] RData2,
    input wire [3:0] ALUOp,
	input wire CalcuSigned,
	output reg Overflow,
    output reg [31:0] Out
    );
	
	always @(*) begin
		Overflow = 0;
		if(ALUOp == 4'h0) begin
			Out = RData1 + RData2;
			if(CalcuSigned)
				if( RData1[31]==RData2[31] && Out[31]!=RData1[31])
					Overflow = 1;
		end
		else if(ALUOp == 4'h1) begin
			Out = RData1 - RData2;
			if(CalcuSigned)
				if( RData1[31]!=RData2[31] && Out[31]!=RData1[31])
					Overflow = 1;
		end
		else if(ALUOp == 4'h2) begin
			Out = RData1 | RData2;
		end
		else if(ALUOp == 4'h3) begin
			Out = RData1 & RData2;
		end
		else if(ALUOp == 4'h4) begin
			Out = RData1 ^ RData2;
		end
		else if(ALUOp == 4'h5) begin
			Out = ~(RData1 | RData2);
		end
		else if(ALUOp == 4'h6) begin
			Out = RData2 << RData1[4:0];
		end
		else if(ALUOp == 4'h7) begin
			Out = RData2 >> RData1[4:0];
		end
		else if(ALUOp == 4'h8) begin
			Out = $signed(RData2) >>> RData1[4:0];
		end
		else begin
			Out = 32'h00000000;
		end
	end
endmodule
