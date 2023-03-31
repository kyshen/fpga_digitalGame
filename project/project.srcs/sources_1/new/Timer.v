`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/30 10:48:20
// Design Name: 
// Module Name: Timer
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


module Timer(
    input clk_1ms,
    output reg [6:0] timer,
    output timer1,
    input EN
    );
    assign timer1 = timer[0];
    reg [10:0] count;
    always @ (posedge clk_1ms) begin
        if(EN==1) begin
            if(count!=1000) count <= count + 1;
            else count<=0;
            
            if(count == 1000) timer <= timer + 1;
            else timer <= timer;
        end
        else begin
            count <= 0;
            timer <= 0;
        end
    end
  
    
endmodule
