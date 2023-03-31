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
    
    
    wire [3:0] d0_adder;    //���ռӷ�������������
    wire [3:0] d1_adder;
    wire [3:0] d2_adder;
    wire [3:0] d3_adder;
    wire [3:0] d4_adder;
    wire [3:0] d5_adder;
    
    wire [6:0] timer;   //��ʱ��ʱ��
    reg EN_timer;   //��ʱ��ʹ��
    reg EN_judge;   //�ж�ģ��ʹ��
    reg EN_Buzzer;
    
    wire [7:0] data1_rand;  //�������������������������
    wire [7:0] data0_rand;
    
    wire [3:0] data0_judge; //�����ж�ģ�鴫��������
    wire [3:0] data1_judge;
    wire [3:0] data2_judge;
    
    always @ (posedge clk_1ms) begin    //data1,data2�̶������judge����ʾ���
        data2 <= data0_judge;   //�ж�ģ��ʹ��֮���û���������չʾ
        data1 <= data1_judge;
        data0 <= data2_judge;
    end
   
    //output wire [1:0] choose;  //�������������ѡ�����
    wire isequal;
    wire isnotequal;
    
    always @ (posedge clk_1ms) begin
        case(choose)    
            2'b00: begin    //�û���û�п�ʼ��ȡ�����
                EN_timer <= 0;
                EN_judge <= 0;  //��ģ�鲻ʹ�ܺ�chooseΪ0��EN_judgeҲΪ0
                {data5,data4} <= {data5,data4};
            end
            2'b01: begin    //�û���ȡ��һ�������
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
            default: begin      //�û���ȡ�����������
                EN_timer <= 1;  //��ʱ����ʼ��ʱ
                EN_judge <= 1;  //�ж�ģ�鿪ʼ�ж�      ע�⣬choose�ոյ�2��˲��EN_judgeʹ�ܣ�������Ȼ�ڰ����ж�ģ���е�keynum�Զ���1
                EN_Buzzer <= 1;
                if(timer <= 7'd1) {data5,data4} <= data1_rand;  //1��֮��ڶ����������ʧ
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
        else begin  //û��ʹ��
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
        .DATA1(d4_adder),   //d5_adder�����λ
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
