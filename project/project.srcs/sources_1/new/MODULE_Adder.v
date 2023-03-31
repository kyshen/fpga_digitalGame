`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/30 14:33:21
// Design Name: 
// Module Name: MODULE_Adder
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


module MODULE_Adder(
    input clk_1ms,
    input clk_sys,
    input [3:0] Col,
    output [3:0] Row,
    output reg [3:0] data0=4'hf,data1=4'hf,data2=4'hf,data3=4'hf,data4=4'hf,data5=4'hf,
    output reg hi,
    input EN     
    );  
    
    wire [23:0] NUMBER1;
    wire [23:0] NUMBER2;
    
    
    wire [3:0] d0_keyinput;
    wire [3:0] d1_keyinput;
    wire [3:0] d2_keyinput;
    wire [3:0] d3_keyinput;
    wire [3:0] d4_keyinput;
    wire [3:0] d5_keyinput;
    
    wire [3:0] d0_adder;
    wire [3:0] d1_adder;
    wire [3:0] d2_adder;
    wire [3:0] d3_adder;
    wire [3:0] d4_adder;
    wire [3:0] d5_adder;
    
    wire hi_wire;
    
    wire iskeying;
    always @ (posedge clk_1ms) begin
        if(iskeying==1 && EN) begin   //如果处于正在键入状态
            data5 <= d5_keyinput;
            data4 <= d4_keyinput;
            data3 <= d3_keyinput;
            data2 <= d2_keyinput;
            data1 <= d1_keyinput;
            data0 <= d0_keyinput;
            hi <= 0;
        end
        else if(iskeying==0 && EN)begin              //如果不处于正在键入状态
             data0 <= d5_adder;
             data1 <= d4_adder;
             data2 <= d3_adder;
             data3 <= d2_adder;
             data4 <= d1_adder;
             data5 <= d0_adder;
             hi <= hi_wire;
        end
        else {data0,data1,data2,data3,data4,data5} <= 24'hffffff;
    end    
    
 
    
KeyIn KeyIn_u(
        .clk_1ms(clk_1ms),
        .Col(Col),
        .Row(Row),
        .data0(d0_keyinput),
        .data1(d1_keyinput),
        .data2(d2_keyinput),
        .data3(d3_keyinput),
        .data4(d4_keyinput),
        .data5(d5_keyinput),
        .NUMBER1(NUMBER1),
        .NUMBER2(NUMBER2),
        .iskeying(iskeying),
        .EN(EN)
    );
    
    add10 add10_u(
        .clk(clk_sys), 
        .NUMBER1(NUMBER1),
        .NUMBER2(NUMBER2),
        .S({d5_adder,d4_adder,d3_adder,d2_adder,d1_adder,d0_adder}),
        .hi(hi_wire)     //最高位进位
    );    
endmodule
