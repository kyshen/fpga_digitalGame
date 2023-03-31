`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 15:43:24
// Design Name: 
// Module Name: Compare2
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


module Compare3(
    input EN,
    input [3:0] DATA0,
    input [3:0] DATA1,
    input [3:0] DATA2,
    input [3:0] data_in0,
    input [3:0] data_in1,
    input [3:0] data_in2,
    output reg isequal,
    output reg isnotequal
    );
    
    always @ (*) begin
        if(EN==1) begin
            if(data_in0==DATA0 && data_in1==DATA1 && data_in2 == DATA2) begin
                isequal <= 1;
                isnotequal <= 0;
             end
            else begin
                isequal <= 0;
                isnotequal <= 1;
            end
        end
        else begin
            isequal <= 0;
            isnotequal <= 0;
        end
    end
endmodule
