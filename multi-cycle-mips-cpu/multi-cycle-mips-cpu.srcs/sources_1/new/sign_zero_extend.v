`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 11:27:47
// Design Name: 
// Module Name: sign_zero_extend
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


module sign_zero_extend(
        input [15:0] immediate,   
        input ExtSel,                 
        output [31:0] extendImmediate
    );
    
    assign extendImmediate[15:0] = immediate;
    assign extendImmediate[31:16] = (ExtSel == 1 ? (immediate[15] ? 16'hffff : 16'h0000) : 16'h0000);
    
endmodule

