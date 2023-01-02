`timescale 1ns / 1ps

module ProgramCounter( input clock, reset, jumpenabled,
                       input [31:0] address,
                       output reg pcvalue );
    always @(posedge clock) begin
        if( reset )
            pcvalue <= 32'h3000;
        else if( jumpenabled )
            pcvalue <= address;
    end
endmodule
