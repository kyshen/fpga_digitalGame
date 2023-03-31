`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 16:43:10
// Design Name: 
// Module Name: rand1
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


module rand1(
    input clk,
    input _EN,
    output reg [3:0]data,
    input _clr 
    );
    
    wire [1:0] _ENs;
    reg [3:0] count;    //计数
    
    always @ (posedge clk) begin
        if(count != 4'b1001) begin      //持续0~9计数
            count = count + 1;
        end
        else begin
            count = 4'b0000;
        end     
        
        if(_ENs==2'b10 && _clr == 1) begin
            data <= count;  //使能“瞬间”的count作为随机数输出
        end
        else if(_ENs!=2'b10 && _clr == 1) begin
            data <= data;
        end
        else 
            data <= 4'hf;
    end



reg_2bit reg_2bit_u(
    .clk(clk),
    .IN(_EN),
    .Q(_ENs)
);    
endmodule
