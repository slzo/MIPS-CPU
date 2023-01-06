`timescale 1ns / 1ps

module DwBits(
    input [31:0] DWRD_W,
    input [2:0] LSel_W,
	input [31:0] A,
    output reg [31:0] DWOut
    );
	always @(*) begin
		case(LSel_W)
			3'b000: DWOut = DWRD_W;
			3'b001:begin
				DWOut = (A[1:0] == 2'b00) ? {{24{DWRD_W[7]}},DWRD_W[7:0]} :
				        (A[1:0] == 2'b01) ? {{24{DWRD_W[15]}},DWRD_W[15:8]} :
					    (A[1:0] == 2'b10) ? {{24{DWRD_W[23]}},DWRD_W[23:16]} :
										    {{24{DWRD_W[31]}},DWRD_W[31:24]};
			end
			3'b010: DWOut = (A[1] == 1'b0) ? {{16{DWRD_W[15]}},DWRD_W[15:0]} : {{16{DWRD_W[31]}},DWRD_W[31:16]};
			3'b101:begin
				DWOut = (A[1:0] == 2'b00) ? {{24{1'b0}},DWRD_W[7:0]} :
				        (A[1:0] == 2'b01) ? {{24{1'b0}},DWRD_W[15:8]} :
					    (A[1:0] == 2'b10) ? {{24{1'b0}},DWRD_W[23:16]} :
										    {{24{1'b0}},DWRD_W[31:24]};
			end
			3'b110: DWOut = (A[1] == 1'b0) ? {{16{1'b0}},DWRD_W[15:0]} : {{16{1'b0}},DWRD_W[31:16]};
			default: DWOut = 32'hffffffff;
		endcase
	end

endmodule
