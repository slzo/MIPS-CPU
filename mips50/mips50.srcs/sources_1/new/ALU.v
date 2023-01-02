`timescale 1ns / 1ps

module ALU( input [31:0] opd1, opd2,
            input [3:0] aluop,
            input sign,
            output reg over,
            output reg [31:0]result );
    always @(*) begin
        over = 0; result = 32'h0;
        case(aluop)
            4'h0: begin
                result = opd1 + opd2;
                if(sign)
                    over = (opd1[31]==opd2[31] && result[31]!=opd1[31]);
            end
            4'h1: begin
                result = opd1 - opd2;
                if(sign)
                    over = (opd1[31]!=opd2[31] && result[31]!=opd1[31]);
            end
            4'h2: begin
                result = opd1|opd2;
            end
            4'h3: begin
                result = opd1&opd2;
            end
            4'h4: begin
                result = opd1^opd2;
            end
            4'h5: begin
                result = ~(opd1|opd2);
            end
            4'h6: begin
                result = opd2 << opd1[4:0];
            end
            4'h7: begin
                result = opd2 >> opd1[4:0];
            end
            4'h8: begin
                result = opd2 >>> opd1[4:0];
            end
        endcase
    end
endmodule
