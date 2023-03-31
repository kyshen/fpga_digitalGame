`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/28 11:40:51
// Design Name: 
// Module Name: add10
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


module add10(
    input clk,
    input [23:0] NUMBER1,
    input [23:0] NUMBER2,
    output [23:0] S,
    output [3:0] test,
    output wire [3:0] a,
    output wire [3:0] b,
    output reg cout,
    output reg cin,
    output reg hi
    );
   
    
    wire [3:0] s;
    reg [4:0] sum;
    assign s = sum[3:0]; 
    reg [3:0] count = 4'b0000;assign test = count;
    always @ (posedge clk) begin       
        if(count != 4'b1111) count <= count + 1;
        else begin
            count <= 4'b0000; 
        end
        
        if(count == 4'b0000) begin
            cin <= 0;
            cout <= 0;
        end
        if(count == 4'b0111) begin
            hi <= cin;
        end
        if(a+b+cin>=5'd10)begin
            cout = 1;
            sum = a+b+cin-5'd10; 
            cin = cout;
        end
        else begin
            cout = 0;
            sum = a + b + cin;
            cin = cout;
        end                        
    end
    
     
     
    
reg_A reg_A_u(
    .clk(clk),
    .NUMBER1(NUMBER1),
    .count(count),
    .a(a)
);

reg_B reg_B_u(
    .clk(clk),
    .NUMBER2(NUMBER2),
    .count(count),
    .b(b)
);

reg_S reg_S_u(
    .clk(clk),
    .count(count),
    .IN(s),
    .S(S)
);     
  
endmodule


module reg_A(
    input clk,
    input [23:0] NUMBER1,
    input [3:0] count,
    output reg [3:0] a
);
    
    always @ (posedge clk) begin
        case(count)
            4'd0:     a <= NUMBER1[3:0];
            4'd1:     a <= NUMBER1[7:4];
            4'd2:     a <= NUMBER1[11:8];
            4'd3:     a <= NUMBER1[15:12];
            4'd4:     a <= NUMBER1[19:16];
            4'd5:     a <= NUMBER1[23:20];
            default:  a <= 4'b0000;

        endcase
    end
endmodule


module reg_B(
    input clk,
    input [23:0] NUMBER2,
    input [3:0] count,
    output reg [3:0] b
);
    
    always @ (posedge clk) begin
        case(count)
            4'd0:     b <= NUMBER2[3:0];
            4'd1:     b <= NUMBER2[7:4];
            4'd2:     b <= NUMBER2[11:8];
            4'd3:     b <= NUMBER2[15:12];
            4'd4:     b <= NUMBER2[19:16];
            4'd5:     b <= NUMBER2[23:20];
            default:  b <= 4'b0000;
        endcase
    end
endmodule


module reg_S(
    input clk,
    input [3:0] IN,
    input [3:0] count,
    output reg [23:0] S = 24'hffffff
);
    reg [23:0] S_temp;
    always @ (posedge clk)begin
        if(count>=4'd2 && count<=4'd7)
            S_temp <= {S_temp[19:0],IN};
        if(count==4'b1111)
            S = S_temp;
    end
      
endmodule