`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 12:04:14
// Design Name: 
// Module Name: ins_seg
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


module ins_seg(
        input [31:0] ins,
        output reg[5:0] op,
        output reg[4:0] rs,
        output reg[4:0] rt,
        output reg[4:0] rd,
        output reg[4:0] sa,
        output reg[15:0] immediate,
        output reg[25:0] addr
    );
    
    initial begin
        op = 5'b00000;
        rs = 5'b00000;
        rt = 5'b00000;
        rd = 5'b00000;
    end
    
    always@(ins) begin
        // R type instruction
        op = ins[31:26];
        rs = ins[25:21];
        rt = ins[20:16];
        rd = ins[15:11];
        sa = ins[10:6];
        // I type instruction
        immediate = ins[15:0];
        // J type instruction
        addr = ins[25:0];
    end
endmodule