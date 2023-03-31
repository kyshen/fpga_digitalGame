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
    input EN,    //����ʹ��
    output reg [7:0] Key_out = 8'b1111_1111,    //�����λ
    output reg [3:0] Key_num,   //�������Ӧ�ó��ֵ����ָ���
    output reg iskeying = 1,    //�û��Ƿ�������
    output reg [1:0] Add_num = 0,   //�û����ӺŵĴ���
    output reg [1:0] choose4rand
    );
    
    

    reg ispress;    //����Q�жϰ����Ƿ��£���������Ϊ1��û�а���Ϊ0
    wire [1:0] ISPRESS;
    reg_2bit reg_2bit_u(
        .clk(clk_1ms),
        .IN(ispress),
        .Q(ISPRESS)
    );    
    
        
    wire IN;
    assign IN = Col[3]*Col[2]*Col[1]*Col[0];    //��ǰ��ɨ�����Ƿ����е�ѹΪ0
    wire [3:0]Q;    //�洢�����ĸ���ɨ���IN
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
            if(Col != 4'b1111)begin     //�ڼ���ʹ�ܵ�����£��������ɨ�赽�м����£��ı������λ
                Key_out <= Key;
            end
            else Key_out <= Key_out;    //���������λ
        
            if(Q == 4'b1111) ispress <= 0;    //�����ǰ�е�ѹȫΪ1��˵��û�а�
            else ispress <= 1;      //�����а�
            
        end
        
        
        else begin      //���̲�ʹ��
            Key_out <= 8'b1111_1111;
        end
    end
    
    
    
    
    
    always @ (posedge clk_1ms) begin
        if(EN==1) begin     //ʹ�������
            if(ISPRESS==2'b01) begin    //�������µ�˲��
                if(Key_out == 8'b1011_1110) begin   //������Ӻ�
                    Key_num <= 0;   //�������Ӧ�ó��ֵ����ָ���Ϊ0�����˼Ӻž��������������
                    if(Add_num!=2'd2) Add_num <= Add_num + 1;   //�û����ӺŵĴ�����һ�����ӵ�3
                    else Add_num <= Add_num; 
                end
                
                else if(Key_out == 8'b1110_1110) begin  //�û����Ⱥţ�˵���û������ټ���������
                    iskeying <= 0;
                end
                
                else if(Key_out == 8'b1110_0111) begin  //�û�����λ
                    iskeying <= 1;  //�û���Ҫ����������
                    Add_num <= 2'b00;   //�Ӽ�����������0
                    Key_num <= 4'b0000;     //�������Ӧ�ó������ָ�����0
                    choose4rand <= 2'b00;
                end
                
                else if(Key_out == 8'b1110_1101 || Key_out == 8'b1101_1110) begin      //����û������������ȡ��
                    if(choose4rand!=2'b11) choose4rand = choose4rand + 1;   //choose4rand����1����ൽ3
                    else choose4rand <= choose4rand;
                end
                
                else begin  
                    if(Key_out == 8'b0111_1110 && Key_num != 0) Key_num <= Key_num - 1;     //DEL������Ļ��Ӧ�ó��ֵ����ָ�����1
                    else if(Key_out == 8'b0111_1110 && Key_num == 0) Key_num <= 0;      //�Ѿ�Ϊ0���ٰ�DEL���Ͳ�Ҫ��1��
                    else if(Key_out != 8'b0111_1110 && Key_num != 4'b0110) Key_num <= Key_num + 1;  //�����ϳ������������Ϊ6
                    else Key_num <= 4'b0110;
                end
            end
            
        end
        
        
        else begin  //������̲�ʹ��
            choose4rand <= 2'b00;   //choose4rand��0
            Key_num <= 0;   //�����ϳ�����������0
            iskeying <= 1;
        end 
    end
    
    
    

    
endmodule
    