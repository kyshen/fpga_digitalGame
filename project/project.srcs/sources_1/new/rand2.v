`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/29 16:43:10
// Design Name: 
// Module Name: rand1
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


module rand2(
    input clk,
    input _EN,
    output reg [7:0]data,
    input _clr 
    );
    
    wire [1:0] _ENs;
    reg [7:0] count;    //计数
    
    always @ (posedge clk) begin
        if(count != 8'h99) begin      //0000_0000 ~~~ 1001_1001; 低位四会出现大于1001
            count = count + 1;
        end
        else begin
            count = 8'd0;
        end     
        
        if(_ENs==2'b10 && _clr == 1) begin
            if(count[3:0]<4'd10)    data <= count;
            else                    data <= count - 8'd7;
        end
        else if(_ENs!=2'b10 && _clr == 1) begin
            data <= data;
        end
        else 
            data <= 8'hff;
    end



reg_2bit reg_2bit_u(
    .clk(clk),
    .IN(_EN),
    .Q(_ENs)
);    
endmodule
