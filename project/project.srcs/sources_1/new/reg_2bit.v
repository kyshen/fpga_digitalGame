`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/24 21:47:30
// Design Name: 
// Module Name: reg_2bit
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


module reg_2bit(
    input clk,
    input IN,
    output reg [1:0] Q = 2'b00
    );
    always @ (posedge clk)begin
        Q <= {Q[0],IN};
    end
endmodule
