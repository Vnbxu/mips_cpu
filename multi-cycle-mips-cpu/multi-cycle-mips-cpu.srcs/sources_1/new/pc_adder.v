`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 11:12:52
// Design Name: 
// Module Name: pc_adder
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


module pc_adder(
        input CLK,    
        input Reset, 
        input [31:0] ReadData,      
        input [1:0] PCSrc,            
        input [31:0] immediate, 
        input [25:0] addr,
        input [31:0] curPC,
        output reg[31:0] nextPC  
    );
    
    initial nextPC <= 0;
    reg [31:0] pc;
    
    always@(negedge CLK or negedge Reset) begin
        if(Reset == 0) begin
            nextPC <= 0;
        end
        else begin
            pc <= curPC + 4;
            case(PCSrc)
                2'b00: nextPC <= curPC + 4;
                2'b01: nextPC <= curPC + 4 + immediate * 4;
                2'b10: nextPC <= ReadData;
                2'b11: nextPC <= {pc[31:28],addr,2'b00};
            endcase
        end
    end
endmodule
