`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/06/01 17:51:24
// Design Name: 
// Module Name: Buzzer_Mozart
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


module Buzzer_Mozart(
    input clk_sys,
    input EN,
    output Buzzer_Mozart
    );
    
    reg [23:0]count2=0;
    reg clk_250ms;
    parameter [23:0]cnt_number2 = 6250000; //250ms
    always @ (posedge clk_sys)begin
        if(count2 == cnt_number2)begin
            clk_250ms = ~clk_250ms;
            count2 = 0;
        end  
        else
            count2 = count2+1;  
    end
    
    reg [4:0] timer;
    always @ (posedge clk_250ms) begin
        if(EN == 1) begin
            if(timer != 5'd16) timer <= timer + 1;
            else timer <= 0;
        end
        else
            timer <= 0;
    end
    
    reg [7:0] SW;
    always @ (posedge clk_sys) begin
        case(timer)
            5'd0:SW <= 8'b00000000;
            5'd1: SW <= {7'b0000000,clk_250ms};
            5'd2: SW <= {7'b0000000,clk_250ms};
            5'd3: SW <= {7'b0000000,clk_250ms};
            5'd4: SW <= {7'b0001111,clk_250ms};
            5'd5: SW <= {7'b0001111,clk_250ms};
            5'd6: SW <= {7'b0011111,clk_250ms};
            5'd7: SW <= {7'b0011111,clk_250ms};
            5'd8: SW <= 8'b00011111;
            5'd9: SW <= 8'b00011111;
            5'd10: SW <= {7'b0000111,clk_250ms};
            5'd11: SW <= {7'b0000111,clk_250ms};
            5'd12: SW <= {7'b0000011,clk_250ms};
            5'd13: SW <= {7'b0000011,clk_250ms};
            5'd14: SW <= {7'b0000001,clk_250ms};
            5'd15: SW <= {7'b0000001,clk_250ms};
            default: SW <= 8'b00000001;
            endcase
    end 
    
    
    Buzzer Buzzer_u(
        .clk(clk_sys),
        .Buzzer(Buzzer_Mozart),
        .SW(SW),
        .EN(EN)
    );   
    
endmodule
