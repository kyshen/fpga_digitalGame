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


module led_disp(
    input clk_1ms,
    input [3:0]data0,
    input [3:0]data1,
    input [3:0]data2,
    input [3:0]data3,
    input [3:0]data4,
    input [3:0]data5,
    output reg [7:0]seg,
    output reg [5:0]dig
    );
    
    reg [23:0] data_buf = 24'hffffff;  //buffer for display, all data for 6 tubes 
    
    //put data into the display buffer, you can write to here by other module
    wire [23:0] data = {data0,data1,data2,data3,data4,data5};
    
    always @ ( data ) begin
        //here we only use the MSB of 6 tubes, you can also use other bits for display
        data_buf[23:20] = data5;
        data_buf[19:16] = data4;
        data_buf[15:12] = data3;
        data_buf[11:8] = data2;
        data_buf[7:4] = data1;
        data_buf[3:0] = data0;
    end 
    
    
    
    reg [2:0] disp_bit=0;  
    reg [3:0] disp_data=0;      //data to display on one digital tube     
    
    //scan 6 tubes one by one
    //DO NOT change !
    always@(posedge clk_1ms)    begin
        if (disp_bit>=5)
            disp_bit<=0;
        else
            disp_bit<=disp_bit+1;
    end
    
    always@( disp_bit)    begin    
        case (disp_bit)
            0:  begin
                disp_data = data_buf[3:0];
                dig = 6'b111110; 
            end  
            1:  begin
                disp_data = data_buf[7:4];
                dig = 6'b111101; 
            end
            2:  begin
                disp_data = data_buf[11:8];           
                dig = 6'b111011; 
            end
            3:   begin
               disp_data = data_buf[15:12]; 
               dig = 6'b110111; 
            end
            4:            begin
                disp_data = data_buf[19:16]; 
                dig = 6'b101111; 
            end
            5:            begin
                disp_data = data_buf[23:20];
                dig = 6'b011111; 
            end
            default: 
                dig = 6'b111111;           
        endcase 
    end
    
    //translate disp_data(the 4-bit binary code) into seven segment code
    //binery number 0000~1001 to dicimal number 0~9, 1010~1111 to custom code, 
    //you can redefine it yourself.    
    always @ ( disp_data )  begin
        case(disp_data)
            4'h0: seg = 8'h7e;  //"0"
            4'h1: seg = 8'h30;  //"1"
            4'h2: seg = 8'h6d;  //"2"
            4'h3: seg = 8'h79;  //"3"
            4'h4: seg = 8'h33;  //"4"
            4'h5: seg = 8'h5b;  //"5"
            4'h6: seg = 8'h1f;  //"6"
            4'h7: seg = 8'h70;  //"7"
            4'h8: seg = 8'h7f;  //"8"
            4'h9: seg = 8'h73;  //"9"
            4'ha: seg = 8'hf7;  //"A."
            4'hb: seg = 8'h95;  //"n."
            4'hc: seg = 8'h86;  //"I."
            4'hd: seg = 8'h01;  //"-"
            4'he: seg = 8'h80;  //"."
            4'hf: seg = 8'h00;  //" "
        endcase
    end
   
endmodule
    