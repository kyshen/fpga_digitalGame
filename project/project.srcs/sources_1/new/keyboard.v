`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/06/11 19:14:22
// Design Name: 
// Module Name: v_DigTube
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


module keyboard(
    input clk_1ms,
    input [3:0] Col,
    output [3:0] Row,
    input EN,    //键盘使能
    output reg [7:0] Key_out = 8'b1111_1111,    //输出键位
    output reg [3:0] Key_num,   //数码管上应该出现的数字个数
    output reg iskeying = 1,    //用户是否在输入
    output reg [1:0] Add_num = 0,   //用户按加号的次数
    output reg [1:0] choose4rand
    );
    
    

    reg ispress;    //根据Q判断按键是否按下，按键按下为1，没有按下为0
    wire [1:0] ISPRESS;
    reg_2bit reg_2bit_u(
        .clk(clk_1ms),
        .IN(ispress),
        .Q(ISPRESS)
    );    
    
        
    wire IN;
    assign IN = Col[3]*Col[2]*Col[1]*Col[0];    //当前行扫描下是否有列电压为0
    wire [3:0]Q;    //存储连续四个行扫描的IN
    reg_4bit reg_4bit_u(
        .clk(clk_1ms),
        .IN(IN),
        .Q(Q)
    );


       
    reg [3:0] RowState = 4'b0111;
    assign Row = RowState;
    wire [7:0] Key = {Row,Col};
    always @(posedge clk_1ms)begin
        RowState <= {RowState[2:0],RowState[3]};
    end
    
    
    
    always @ (posedge clk_1ms) begin
        if(EN == 1) begin
            if(Col != 4'b1111)begin     //在键盘使能的情况下，如果有行扫描到有键按下，改变输出键位
                Key_out <= Key;
            end
            else Key_out <= Key_out;    //保持输出键位
        
            if(Q == 4'b1111) ispress <= 0;    //如果当前列电压全为1，说明没有按
            else ispress <= 1;      //否则有按
            
        end
        
        
        else begin      //键盘不使能
            Key_out <= 8'b1111_1111;
        end
    end
    
    
    
    
    
    always @ (posedge clk_1ms) begin
        if(EN==1) begin     //使能情况下
            if(ISPRESS==2'b01) begin    //按键按下的瞬间
                if(Key_out == 8'b1011_1110) begin   //如果按加号
                    Key_num <= 0;   //数码管上应该出现的数字个数为0，按了加号就重新输出被加数
                    if(Add_num!=2'd2) Add_num <= Add_num + 1;   //用户按加号的次数加一，最多加到3
                    else Add_num <= Add_num; 
                end
                
                else if(Key_out == 8'b1110_1110) begin  //用户按等号，说明用户不用再继续输入了
                    iskeying <= 0;
                end
                
                else if(Key_out == 8'b1110_0111) begin  //用户按复位
                    iskeying <= 1;  //用户又要继续输入了
                    Add_num <= 2'b00;   //加键被按次数归0
                    Key_num <= 4'b0000;     //数码管上应该出现数字个数归0
                    choose4rand <= 2'b00;
                end
                
                else if(Key_out == 8'b1110_1101 || Key_out == 8'b1101_1110) begin      //如果用户按下随机数获取键
                    if(choose4rand!=2'b11) choose4rand = choose4rand + 1;   //choose4rand递增1，最多到3
                    else choose4rand <= choose4rand;
                end
                
                else begin  
                    if(Key_out == 8'b0111_1110 && Key_num != 0) Key_num <= Key_num - 1;     //DEL键，屏幕上应该出现的数字个数减1
                    else if(Key_out == 8'b0111_1110 && Key_num == 0) Key_num <= 0;      //已经为0了再按DEL减就不要减1了
                    else if(Key_out != 8'b0111_1110 && Key_num != 4'b0110) Key_num <= Key_num + 1;  //键盘上出现数字数最多为6
                    else Key_num <= 4'b0110;
                end
            end
            
        end
        
        
        else begin  //如果键盘不使能
            choose4rand <= 2'b00;   //choose4rand归0
            Key_num <= 0;   //键盘上出现数字数归0
            iskeying <= 1;
        end 
    end
    
    
    

    
endmodule
    