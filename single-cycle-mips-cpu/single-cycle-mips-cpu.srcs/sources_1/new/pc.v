`timescale 1ns / 1ps

module pc(
       input CLK,              
       input Reset,            
       input PCWre,       
       input [1:0] PCSrc,       
       input [31:0] nextPC,  
       output reg[31:0] curPC
    );
    
    initial curPC <= 0;

    always@(posedge CLK or posedge Reset) begin
        if(!Reset) curPC <= 0;
        else begin
            if(PCWre == 1) curPC <= nextPC;
            else curPC <= curPC;
        end
    end
endmodule
