`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/26 11:05:53
// Design Name: 
// Module Name: KEYNUM
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


module KEYNUM(
    input clk,
    input [3:0] IN,
    output reg [7:0] Q = 8'b0000_0000
    );
    always @ (posedge clk)begin
        Q <= {Q[3:0],IN};
    end
endmodule
