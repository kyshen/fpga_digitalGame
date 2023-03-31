`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 15:49:19
// Design Name: 
// Module Name: Judge2
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


module Judge3(
    input clk,
    input EN,
    input [3:0] DATA0,  //标准比较值
    input [3:0] DATA1,  //标准比较值
    input [3:0] DATA2,
    input [3:0] Col,
    output [3:0] Row,
    output reg [3:0] data0,     //用户输入比较值，并作为输出
    output reg [3:0] data1,
    output reg [3:0] data2,
    output isequal,     //判断相等与否
    output isnotequal
    );
    
    reg startCompare = 0;
    wire [7:0] Key;
    wire [3:0] Key_num;
    wire [7:0] Key_num_reg;

    reg [3:0] dispdata; 
    wire iskeying;
    always @ (posedge clk) begin
        case(Key)
            8'b0111_0111:   dispdata <= 4'd7;
            8'b0111_1011:   dispdata <= 4'd8;
            8'b0111_1101:   dispdata <= 4'd9;
            8'b0111_1110:   dispdata <= 4'hb;//DEL 随便赋值
            
            8'b1011_0111:   dispdata <= 4'd4;
            8'b1011_1011:   dispdata <= 4'd5;
            8'b1011_1101:   dispdata <= 4'd6;
            8'b1011_1110:   dispdata <= 4'ha;//+
                                
            
            8'b1101_0111:   dispdata <= 4'd1;
            8'b1101_1011:   dispdata <= 4'd2;
            8'b1101_1101:   dispdata <= 4'd3;
            8'b1101_1110:   dispdata <= 4'ha;
            
            8'b1110_0111:   dispdata <= 4'ha;// rechoose
            8'b1110_1011:   dispdata <= 4'd0;
            8'b1110_1101:   dispdata <= 4'ha;
            8'b1110_1110:   dispdata <= 4'ha;// = 
            default:        dispdata <= 4'hf;
        endcase
    end
    
    
    always @ (posedge clk) begin    
        if(EN == 1) begin   //如果判断模块使能
            if(iskeying==1) begin
                if(Key_num_reg[7:4] != Key_num_reg[3:0])begin   //只在
                    case(Key_num)
                        4'b0000: begin      //还没输入时
                            data0 <= 4'hf;  
                            data1 <= 4'hf;               
                        end
                        4'b0001: begin      //刚刚使能时键盘是按着的，所以这是起始位置。输入第一个数，keynum从2开始
                            data0 <= 4'hf;  
                            data1 <= 4'hf; 
                        end
                        4'b0010: begin      //按了一次
                            data0 <= dispdata;
                        end
                        4'b0011: begin      //按了两次
                            data1 <= dispdata;
                        end
                        4'b0100: begin      //按了三次
                            data2 <= dispdata;
                        end                        
                        default: data2 <= dispdata;     //继续按只改变data2
                    endcase
                end
            end
            else begin  //如果用户按 = 了
                startCompare <= 1; //开始比较
            end
        end
        else begin
            data2 <= 4'hf;
            data1 <= 4'hf;
            data0 <= 4'hf;
            startCompare <= 0;  //没有使能的时候，置0，否则下一次直接开始比较
        end
    end
    
    
KEYNUM KEYNUM_u(
    .clk(clk),
    .IN(Key_num),
    .Q(Key_num_reg)
    );
    
Compare3 Compare3_u(
    .EN(startCompare),
    .DATA0(DATA0),
    .DATA1(DATA1),
    .DATA2(DATA2),
    .data_in0(data0),
    .data_in1(data1),
    .data_in2(data2),
    .isequal(isequal),
    .isnotequal(isnotequal)
);

keyboard keyboard_u(
    .clk_1ms(clk),
    .Col(Col),
    .Row(Row),
    .Key_out(Key),
    .Key_num(Key_num),
    .iskeying(iskeying),
    .EN(EN)
);
endmodule
