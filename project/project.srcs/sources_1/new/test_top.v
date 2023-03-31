`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/21 17:32:57
// Design Name: 
// Module Name: test_top
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


module test_top(
    input clk_sys,
    input sw11,sw10,sw9,sw8,sw7,sw6,sw5,sw4,sw3,
    output [7:0]seg,
    output [5:0]dig,
    input [3:0] Col,
    output [3:0] Row,
    output [3:0] leds,
    output [3:0] testleds,
    output LED12,LED13,LED14,LED15,LED16,
    output reg Buzzer
    );
    
    reg [23:0]count1=0;
    reg [23:0]count2=0;
    reg [23:0]count3=0;
    parameter [23:0]cnt_number1 = 25000;  //1ms
    parameter [23:0]cnt_number2 = 125;
    parameter [23:0]cnt_number3 = 7000000;
    reg clk_1ms;
    reg clk_test;
    reg clk4led;
    always @ (posedge clk_sys)begin
        if( count1 == cnt_number1 ) begin
            clk_1ms = ~clk_1ms;
            count1 = 0;
        end
        else
            count1 = count1+1;
    end
    always @ (posedge clk_sys)begin
        if(count2 == cnt_number2)begin
            clk_test = ~clk_test;
            count2 = 0;
        end  
        else
            count2 = count2+1;  
    end
    always @ (posedge clk_sys)begin
        if(count3 == cnt_number3)begin
            clk4led = ~clk4led;
            count3 = 0;
        end  
        else
            count3 = count3+1;  
    end 
    
    wire light_shine_1;
    wire light_shine_2;
    reg light_shine;
    assign LED16 = light_shine;
    assign LED15 = light_shine;
    assign LED14 = light_shine;
    assign LED13 = light_shine;
    assign LED12 = light_shine;
    
    wire Buzzer_1;
    wire Buzzer_2;
    

    reg [3:0] data0,data1,data2,data3,data4,data5;
    
    wire [3:0] data0_1,data1_1,data2_1,data3_1,data4_1,data5_1;
    wire [3:0] data0_2,data1_2,data2_2,data3_2,data4_2,data5_2;
    wire [3:0] data0_add,data1_add,data2_add,data3_add,data4_add,data5_add;
    
    
    wire fail_1,success_1;  
    wire fail_2,success_2; 
    reg EN_1,EN_2,EN_add; 
    
    
    always @ (posedge clk_sys) begin
        if({sw11,sw10,sw9}==3'b001 || {sw11,sw10,sw9}==3'b011 || {sw11,sw10,sw9}==3'b101 || {sw11,sw10,sw9}==3'b111)begin
             EN_2 <= 1;
             EN_1 <= 0;
             EN_add <= 0;
            {data0,data1,data2,data3,data4,data5} <= {data0_2,data1_2,data2_2,data3_2,data4_2,data5_2};
            light_shine <= light_shine_2;
            Buzzer <= Buzzer_2;
        end
        else if({sw11,sw10,sw9}==3'b010 || {sw11,sw10,sw9}==3'b110) begin
             EN_2 <= 0;
             EN_1 <= 1;
             EN_add <= 0;        
            {data0,data1,data2,data3,data4,data5} <= {data0_1,data1_1,data2_1,data3_1,data4_1,data5_1};
            light_shine <= light_shine_1;
            Buzzer <= Buzzer_1;
        end
        else if({sw11,sw10,sw9}==3'b100) begin
             EN_2 <= 0;
             EN_1 <= 0;
             EN_add <= 1; 
            {data0,data1,data2,data3,data4,data5} <= {data0_add,data1_add,data2_add,data3_add,data4_add,data5_add};
        end
        else begin
             EN_2 <= 0;
             EN_1 <= 0;
             EN_add <= 0; 
            {data0,data1,data2,data3,data4,data5} <= 24'hffffff;
            light_shine <= 0;
        end
    end
    
    reg [3:0] LEDS = 4'b1000;
    assign leds = LEDS;
    always @ (posedge clk4led) begin
        if(success_1==1 || success_2==1) begin
            LEDS <= {LEDS[0],LEDS[3:1]};
        end
        else begin
            LEDS <= 4'b1000;
        end
    end
    
     
    MODULE_2 MODULE_2_u(
        .clk_1ms(clk_1ms),
        .clk_sys(clk_sys),
        .clk_test(clk_test),
        .Col(Col),
        .Row(Row),
        .data0(data0_2),
        .data1(data1_2),
        .data2(data2_2),
        .data3(data3_2),
        .data4(data4_2),
        .data5(data5_2),
        .fail(fail_2),
        .success(success_2),
        .Buzzer(Buzzer_2),
        .EN(EN_2),
        .light_shine(light_shine_2)
    );

    MODULE_1 MODULE_1_u(
        .clk_1ms(clk_1ms),
        .clk_sys(clk_sys),
        .clk_test(clk_test),
        .Col(Col),
        .Row(Row),
        .data0(data0_1),
        .data1(data1_1),
        .data2(data2_1),
        .data3(data3_1),
        .data4(data4_1),
        .data5(data5_1),
        .fail(fail_1),
        .success(success_1),
        .Buzzer(Buzzer_1),
        .EN(EN_1),
        .light_shine(light_shine_1)
    );
    
   MODULE_Adder MODULE_Adder_u(
        .clk_1ms(clk_1ms),
        .clk_sys(clk_sys),
        .Col(Col),
        .Row(Row),
        .data0(data0_add),
        .data1(data1_add),
        .data2(data2_add),
        .data3(data3_add),
        .data4(data4_add),
        .data5(data5_add),
        .hi(testleds[0]),
        .EN(EN_add)        
    );
    
/*Buzzer_Mozart Buzzer_Mozart_u(
    .clk_sys(clk_sys),
    .EN(sw11),
    .Buzzer_Mozart(Buzzer)
);*/
 
led_disp led_disp_u(
    .clk_1ms(clk_1ms),
    .data0(data0),
    .data1(data1),
    .data2(data2),
    .data3(data3),
    .data4(data4),
    .data5(data5),
    .seg(seg),
    .dig(dig)  
);
                  

endmodule
