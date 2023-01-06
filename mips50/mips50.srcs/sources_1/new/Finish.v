`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/06/2023 08:29:34 PM
// Design Name: 
// Module Name: Finish
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Finish( input wire [31:0] Ins );
    integer file;
    initial begin file = $fopen("/home/soda/cpu/pipline/Mips50TestCodeAns/TestAns/myans.txt");
    end
    always @(Ins) begin
        if( Ins[31:26]==6'b000000 && Ins[5:0]==6'b001100 ) begin
            $fclose(file);
            $finish;
        end
    end
endmodule
