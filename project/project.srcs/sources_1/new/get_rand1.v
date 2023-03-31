`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 16:55:37
// Design Name: 
// Module Name: get_rand1
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


module get_rand1(
    input clk,
    input clk_test,     //随机数发生器所用时钟
    input [3:0] Col,
    output [3:0] Row,
    output reg [3:0] data0,
    output reg [3:0] data1,
    output wire [1:0] choose,   //接收键盘模块传出的choose4rand，并作为输出
    input EN    //使能
    );

    reg _EN1 = 1;
    reg _EN2 = 1;   //默认随机数发生器不使能
    
    
    
    wire [3:0] DATA0;    //获取的两个随机数，先获取DATA0，再获取DATA1
    wire [3:0] DATA1;
    always @ (posedge clk) begin
        if(EN == 1) begin
            data0 <= DATA0;
            data1 <= DATA1;
        end
        else begin
            data0 <= 4'hf;
            data1 <= 4'hf;
        end 
    end    
    
    
    always @ (posedge clk) begin
        case(choose)
            2'b00: begin
                _EN1 <= 1;
                _EN2 <= 1;
            end
            2'b01: begin
               _EN1 <= 0;   //第一个随机数发生器使能
               _EN2 <= 1;
            end
            2'b10: begin
               _EN1 <= 1;
               _EN2 <= 0;   //第二个随机数发生器使能
            end
            default: begin
                _EN1 <= 1;
                _EN2 <= 1;                
            end
        endcase
    end
    
 
 keyboard Keyboard(
    .clk_1ms(clk),
    .Col(Col),
    .Row(Row),
    .choose4rand(choose),
    .EN(EN)
 );
 
rand1 rand1_u1(
    .clk(clk_test),
    ._EN(_EN1),
    .data(DATA0),
    ._clr(EN)
);

rand1 rand1_u2(
    .clk(clk_test),
    ._EN(_EN2),
    .data(DATA1),
    ._clr(EN)
);

endmodule






