`timescale 1ns / 1ps

module ID_EX( input wire [31:0] ID_EX_INS,
              input wire [4:0] EX_MEM_REG, MEM_WB_REG,
              input wire busy,
              
              output wire [3:0] aluop,
              output wire alusrc1, alusrc2, sign,
              output wire [1:0] mdop, mdwrite,
              output wire [3:0] resultsrc, aluopd1, aluopd2, dmsrc, T,
              output wire STOP );
    assign mdop = (op==`CALCU & (func==`MULT|func==`MULTU) ) ? 2'b01 :
                  (op==`CALCU & (func==`DIV |func==`DIVU)  ) ? 2'b10 : 2'b00;
    
endmodule
