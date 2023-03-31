`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/26 11:33:54
// Design Name: 
// Module Name: reg_24bit
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


module reg_24bit(
    input EN,
    input clk, 
    input [3:0] data5,
    input [3:0] data4,
    input [3:0] data3,
    input [3:0] data2,
    input [3:0] data1,
    input [3:0] data0,
    output reg [23:0] Q = 24'b0000_0000_0000_0000_0000_0001
    );
    always @ (posedge clk)begin
        if(EN == 1)begin
            Q <= {data5,data4,data3,data2,data1,data0};
        end
        else Q <= Q;
    end
endmodule
