`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 11:55:22
// Design Name: 
// Module Name: IR
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


module IR(
    input CLK,
    input IRWre,
    input [31:0] in_data,
    output reg [31:0] out_data
    );
    
    initial out_data = 0;

    always@(posedge CLK) begin
        if(IRWre == 1) begin
            out_data = in_data;
        end
    end
endmodule
