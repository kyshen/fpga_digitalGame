`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/30 14:06:18
// Design Name: 
// Module Name: MODULE_1
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


module MODULE_2(
    input clk_1ms,
    input clk_test,
    input clk_sys,
    input [3:0] Col,
    output [3:0] Row,
    output reg [3:0] data0=4'hf,data1=4'hf,data2=4'hf,data3=4'hf,data4=4'hf,data5=4'hf,
    output reg fail,
    output reg success,
    input EN,
    output wire [1:0] choose,
    output Buzzer,
    output light_shine    
    );
    
    
    wire [3:0] d0_adder;    //接收加法器传出的数据
    wire [3:0] d1_adder;
    wire [3:0] d2_adder;
    wire [3:0] d3_adder;
    wire [3:0] d4_adder;
    wire [3:0] d5_adder;
    
    wire [6:0] timer;   //计时器时间
    reg EN_timer;   //计时器使能
    reg EN_judge;   //判断模块使能
    reg EN_Buzzer;
    
    wire [7:0] data1_rand;  //接受随机数发生器传出的数据
    wire [7:0] data0_rand;
    
    wire [3:0] data0_judge; //接收判断模块传出的数据
    wire [3:0] data1_judge;
    wire [3:0] data2_judge;
    
    always @ (posedge clk_1ms) begin    //data1,data2固定分配给judge的显示输出
        data2 <= data0_judge;   //判断模块使能之后，用户键入数据展示
        data1 <= data1_judge;
        data0 <= data2_judge;
    end
   
    //output wire [1:0] choose;  //随机数发生器的选择变量
    wire isequal;
    wire isnotequal;
    
    always @ (posedge clk_1ms) begin
        case(choose)    
            2'b00: begin    //用户还没有开始获取随机数
                EN_timer <= 0;
                EN_judge <= 0;  //主模块不使能后，choose为0，EN_judge也为0
                {data5,data4} <= {data5,data4};
            end
            2'b01: begin    //用户获取了一个随机数
                EN_timer <= 0;
                EN_judge <= 0;
                {data5,data4} <= data0_rand;
            end
            /*2'b10: begin
                EN_judge <= 1;
                EN_timer <= 1;
                if(timer <= 7'd2) data5 <= data1_rand;
                else begin
                    data5 <= 4'hf;
                end
            end*/
            default: begin      //用户获取了两个随机数
                EN_timer <= 1;  //计时器开始计时
                EN_judge <= 1;  //判断模块开始判断      注意，choose刚刚到2的瞬间EN_judge使能，按键仍然在按，判断模块中的keynum自动加1
                EN_Buzzer <= 1;
                if(timer <= 7'd1) {data5,data4} <= data1_rand;  //1秒之后第二个随机数消失
                else begin
                    {data5,data4} <= 8'hff;
                end
            end
        endcase
        

        if(EN == 1 && timer <= 7'd8) begin
            if(isequal == 1 && isnotequal == 0) begin
                success <= 1; fail <= 0;
            end
            else if(isequal == 0 && isnotequal == 1) begin
                success <= 0; fail <= 1;
            end
            else begin
                success <= 0; fail <= 0;                
            end     
        end
        else if(EN == 1 && timer > 7'd8) begin
            if(success == 1) fail <= 0;
            else fail <= 1;
        end
        else begin  //没有使能
            EN_timer <= 0;
            EN_Buzzer <= 0;
            success <= 0;
            fail <= 0;
        end
        
    end

    
    get_rand2 get_rand2_u(
        .clk(clk_1ms),
        .clk_test(clk_test),
        .Col(Col),
        .Row(Row),
        .data1(data1_rand),
        .data0(data0_rand),
        .choose(choose),
        .EN(EN)
    );
    
    Judge3 Judge3_u(
        .clk(clk_1ms),
        .DATA0(d3_adder),
        .DATA1(d4_adder),   //d5_adder是最低位
        .DATA2(d5_adder),
        .Col(Col),
        .Row(Row),
        .data0(data0_judge),
        .data1(data1_judge),
        .data2(data2_judge),
        .isequal(isequal),
        .isnotequal(isnotequal),
        .EN(EN_judge)
    );
    
    add10 add10_u(
        .clk(clk_sys),
        .NUMBER1({4'b0000,4'b0000,4'b0000,4'b0000,data0_rand}),
        .NUMBER2({4'b0000,4'b0000,4'b0000,4'b0000,data1_rand}),
        .S({d5_adder,d4_adder,d3_adder,d2_adder,d1_adder,d0_adder})
    );
    
    Timer Timer_u(
        .clk_1ms(clk_1ms),
        .timer(timer),
        .EN(EN_timer)
    );
    
    Buzzer_shine Buzzer_shine_u(
        .clk_sys(clk_sys),
        .clk_1ms(clk_1ms),
        .Buzzer(Buzzer),
        .timer(timer),
        .EN(EN_Buzzer),
        .light_shine(light_shine),
        .success(success),
        .fail(fail)
    );
    
         
endmodule
