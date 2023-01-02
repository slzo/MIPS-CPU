`timescale 1ns / 1ps

module DataMemory( input reset, clock, readenabled,
                   input [3:0] writeenabled,
                   input [31:0] address, writeinput,
                   output reg [31:0] readdata );
    reg [31:0] datamemory[2047:0];
    integer i;
    always @(posedge clock) begin
        if( reset ) 
            for( i = 0; i < 2048; i=i+1 )
                datamemory[i] <= 32'b0;
        else begin
            case(writeenabled)
                4'b0001: begin
                    datamemory[address][7:0] <= writeinput[7:0];
				    $display("@%h: *%h <= %h", PC, {{16{1'b0}}, address[15:2], {2{1'b0}}}, {datamemory[address][31:8], writeinput[7:0]});
                end
                4'b0010: begin
                    datamemory[address][15:8] <= writeinput[7:0];
				    $display("@%h: *%h <= %h", PC, {{16{1'b0}}, address[15:2], {2{1'b0}}}, {datamemory[address][31:16], writeinput[7:0], datamemory[address][7:0]});
                end
                4'b0100: begin
                    datamemory[address][23:16] <= writeinput[7:0];
				    $display("@%h: *%h <= %h", PC, {{16{1'b0}}, address[15:2], {2{1'b0}}}, {datamemory[address][31:24], writeinput[7:0], datamemory[address][15:0]});
                end
                4'b1000: begin
                    datamemory[address][31:24] <= writeinput[7:0];
				    $display("@%h: *%h <= %h", PC, {{16{1'b0}}, address[15:2], {2{1'b0}}}, {writeinput[7:0], datamemory[address][23:0]});
                end
                4'b0011: begin
                    datamemory[address][15:0] <= writeinput[15:0];
				    $display("@%h: *%h <= %h", PC, {{16{1'b0}}, address[15:2], {2{1'b0}}}, {datamemory[address][31:16], writeinput[15:0]});
                end
                4'b1100: begin
                    datamemory[address][31:16] <= writeinput[15:0];
				    $display("@%h: *%h <= %h", PC, {{16{1'b0}}, address[15:2], {2{1'b0}}}, {writeinput[15:0], datamemory[address][15:0]});
                end
                4'b1111: begin
                    datamemory[address] <= writeinput;
				    $display("@%h: *%h <= %h", PC, {{16{1'b0}}, address[15:2], {2{1'b0}}}, writeInput);
                end
            endcase
        end        
    end
    always @(*) begin
        if( readenabled )
            readdata <= datamemory[address];
    end

endmodule
