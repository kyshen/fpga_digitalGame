`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/01 16:14:10
// Design Name: 
// Module Name: Buzzer_shine
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


module Buzzer_shine(
    input clk_sys,
    input clk_1ms,
    output reg Buzzer,
    input [6:0] timer,
    input EN,
    output reg light_shine,
    
    input fail,
    input success
    );
    
    reg [23:0]count1=0;
    reg [23:0]count2=0;
    reg [23:0]count3=0;
    reg [23:0]count4=0;
    reg [24:0]count5=0;
    parameter [23:0]cnt_number1 = 3125000;  //125ms
    parameter [23:0]cnt_number2 = 6250000; //250ms
    parameter [23:0]cnt_number3 = 12500000; //500ms
    parameter [23:0]cnt_number4 = 1562500; //60ms
    parameter [24:0]cnt_number5 = 18750000; //750ms
    reg clk_60ms;
    reg clk_125ms;
    reg clk_250ms;
    reg clk_500ms;
    reg clk_750ms;
    always @ (posedge clk_sys)begin
        if( count1 == cnt_number1 ) begin
            clk_125ms = ~clk_125ms;
            count1 = 0;
        end
        else
            count1 = count1+1;
    end
    always @ (posedge clk_sys)begin
        if(count2 == cnt_number2)begin
            clk_250ms = ~clk_250ms;
            count2 = 0;
        end  
        else
            count2 = count2+1;  
    end
    always @ (posedge clk_sys)begin
        if(count3 == cnt_number3)begin
            clk_500ms = ~clk_500ms;
            count3 = 0;
        end  
        else
            count3 = count3+1;  
    end
    always @ (posedge clk_sys)begin
        if(count4 == cnt_number4)begin
            clk_60ms = ~clk_60ms;
            count4 = 0;
        end  
        else
            count4 = count4+1;  
    end
    always @ (posedge clk_sys)begin
        if(count5 == cnt_number5)begin
            clk_750ms = ~clk_750ms;
            count5 = 0;
        end  
        else
            count5 = count5+1;  
    end
    
    wire Buzzer_1;  //
    wire Buzzer_2;  //成功
    wire Buzzer_3;  //失败
    
    reg [7:0] SW;
    reg EN_Mozart;
    always @ (posedge clk_sys) begin
    if(EN==1) begin
        if(success == 1 && fail == 0) begin //判定成功  
            light_shine <= 0;
            EN_Mozart <= 1;
            Buzzer <= Buzzer_2;
        end
        else if(success == 0 && fail == 1)  begin   //判定失败
            light_shine <= 1;
            EN_Mozart <= 0;
            Buzzer <= Buzzer_3;
        end
        else if(success == 0 && fail == 0)  begin   //未判定  
            Buzzer <= Buzzer_1;
            if(timer <= 7'd2) begin SW <= {7'b1111111,clk_750ms}; light_shine <= clk_750ms; end
            else if(timer > 7'd2 && timer <= 7'd4)  begin SW <= {7'b1111111,clk_500ms}; light_shine <= clk_500ms; end
            else if(timer > 7'd4 && timer <= 7'd6)  begin SW <= {7'b1111111,clk_250ms}; light_shine <= clk_250ms; end
            else if(timer > 7'd6 && timer <= 7'd7) begin SW <= {7'b1111111,clk_125ms}; light_shine <= clk_125ms; end
            else if(timer > 7'd7 && timer <= 7'd8) begin SW <= {7'b1111111,clk_60ms}; light_shine <= clk_60ms; end
            else  begin SW <= 8'b11111111; light_shine <= 1; end
        end
    end
    else begin  //没有使能
        light_shine <= 0;
    end
    end    

    
    Buzzer Buzzer_u(
        .clk(clk_sys),
        .SW({SW}),
        .Buzzer(Buzzer_1),
        .EN(EN)
    );
    
    Buzzer_Mozart Buzzer_Mozart(
        .clk_sys(clk_sys),
        .Buzzer_Mozart(Buzzer_2),
        .EN(EN_Mozart)
    ); 
    
    Buzzer Buzzer_u0(
        .clk(clk_sys),
        .SW(8'b00000001),
        .Buzzer(Buzzer_3),
        .EN(EN)
    );   
endmodule
