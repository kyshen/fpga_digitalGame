`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/24 21:23:13
// Design Name: 
// Module Name: reg_4bit
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


module reg_4bit(
    input clk,
    input IN,
    output reg [3:0] Q = 4'b1111
    );
    always @ (posedge clk)begin
        Q <= {Q[2:0],IN};
    end
endmodule
