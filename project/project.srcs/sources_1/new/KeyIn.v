`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/25 02:43:37
// Design Name: 
// Module Name: KeyIn
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


module KeyIn(
    input clk_1ms,
    output reg [3:0] data0,
    output reg [3:0] data1,
    output reg [3:0] data2,
    output reg [3:0] data3,
    output reg [3:0] data4,
    output reg [3:0] data5,
    
    output iskeying,
    input [3:0] Col,
    output [3:0] Row,
    output wire [1:0] Add_num,
    output wire [23:0] NUMBER1,
    output wire [23:0] NUMBER2,
    input EN
    );
    
    
    reg start;
    
    reg [2:0] ENs = 3'b000;
    wire [23:0] NUMBER3;
    
    wire [23:0] SUM;
    
    wire [7:0] Key;
    wire [3:0] Key_num;
    wire [7:0] Key_num_reg;
     
    reg [3:0] dispdata;    
    always @ (posedge clk_1ms)begin
        case(Key)
            8'b0111_0111:   dispdata <= 4'd7;
            8'b0111_1011:   dispdata <= 4'd8;
            8'b0111_1101:   dispdata <= 4'd9;
            8'b0111_1110:   dispdata <= 4'hb;//DEL Ëæ±ã¸³Öµ
            
            8'b1011_0111:   dispdata <= 4'd4;
            8'b1011_1011:   dispdata <= 4'd5;
            8'b1011_1101:   dispdata <= 4'd6;
            8'b1011_1110:   dispdata <= 4'ha;//+
                                
            
            8'b1101_0111:   dispdata <= 4'd1;
            8'b1101_1011:   dispdata <= 4'd2;
            8'b1101_1101:   dispdata <= 4'd3;
            8'b1101_1110:   dispdata <= 4'ha;
            
            8'b1110_0111:   dispdata <= 4'ha;//rechoose
            8'b1110_1011:   dispdata <= 4'd0;
            8'b1110_1101:   dispdata <= 4'ha;
            8'b1110_1110:   dispdata <= 4'ha;//=
 
            
            default:        dispdata <= 4'hf;
        endcase
        
        if(iskeying==1) begin
            if(Key_num_reg[7:4] != Key_num_reg[3:0])begin
                    if(Key_num != 0 && Key != 8'b0111_1110)begin                   
                            case(Key_num)
                                4'd1:   data5 <= dispdata;
                                4'd2:   data4 <= dispdata;
                                4'd3:   data3 <= dispdata;
                                4'd4:   data2 <= dispdata;
                                4'd5:   data1 <= dispdata;
                                4'd6:   data0 <= dispdata;
                            endcase                   
                    end
                    else if(Key_num != 0 && Key == 8'b0111_1110)begin
                        case(Key_num)
                            4'd1:   data4 <= 4'hf;
                            4'd2:   data3 <= 4'hf; 
                            4'd3:   data2 <= 4'hf; 
                            4'd4:   data1 <= 4'hf; 
                            4'd5:   data0 <= 4'hf;   
                        endcase
                    end
                    else begin
                        data5 <= 4'hf;
                        data4 <= 4'hf;
                        data3 <= 4'hf;
                        data2 <= 4'hf;
                        data1 <= 4'hf;
                        data0 <= 4'hf;
                    end
            end
        end    
    end
    
    
    always @ (posedge clk_1ms)begin
        if(Add_num == 2'd0) ENs <= 3'b100;
        else if(Add_num == 2'd1) ENs <= 3'b010;
        else if(Add_num == 2'd2) ENs <= 3'b010;
        else if(Add_num == 2'd3) ENs <= 3'b001;
        else ENs <= 3'b000;
    end

      
KEYNUM KEYNUM_u(
    .clk(clk_1ms),
    .IN(Key_num),
    .Q(Key_num_reg)
);   
    
keyboard keyboard_u(
    .clk_1ms(clk_1ms),
    .Col(Col),
    .Row(Row),
    .Key_out(Key),
    .Key_num(Key_num),
    .iskeying(iskeying),
    .Add_num(Add_num),
    .EN(EN)
);

reg_24bit reg_24bit_u1(
    .clk(clk_1ms),
    .EN(ENs[2]),
    .data5(data5),
    .data4(data4),
    .data3(data3),
    .data2(data2),
    .data1(data1),
    .data0(data0),
    .Q(NUMBER1)  
);

reg_24bit reg_24bit_u2(
    .clk(clk_1ms),
    .EN(ENs[1]),
    .data5(data5),
    .data4(data4),
    .data3(data3),
    .data2(data2),
    .data1(data1),
    .data0(data0),
    .Q(NUMBER2)  
);

reg_24bit reg_24bit_u3(
    .clk(clk_1ms),
    .EN(ENs[0]),
    .data5(data5),
    .data4(data4),
    .data3(data3),
    .data2(data2),
    .data1(data1),
    .data0(data0),
    .Q(NUMBER3)
);


endmodule
