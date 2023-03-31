`timescale 1ns / 1ps


module Buzzer(
   input clk,
   output reg Buzzer,
   input[7:0] SW,
   input EN
    );

    reg [19:0] cnt;
    reg[19:0] tone_div;

    always@(*)
     case(SW)
     8'b00000001 :tone_div <= 20'd95602;
     8'b00000011 :tone_div <= 20'd85178;
     8'b00000111 :tone_div <= 20'd75872;
     8'b00001111 :tone_div <= 20'd71632;
     8'b00011111 :tone_div <= 20'd63776;
     8'b00111111 :tone_div <= 20'd56818;
     8'b01111111  :tone_div <= 20'd50606;
     8'b11111111  :tone_div <= 20'd47800;
     default:tone_div <= 0;
     endcase


     always@(posedge clk) begin
        if(EN == 1) begin
              if( tone_div == 0) begin
                     cnt<=0;     //清零
                     Buzzer<=0;   //时钟翻转
              end
              else if(cnt == tone_div) begin
                     cnt<=0;     //清零
                     Buzzer<=~Buzzer;   //时钟翻转
              end
              else
                     cnt<=cnt+1;
         end
         else begin     //如果不使能
            Buzzer <= 0;
         end
      end
endmodule