`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 12:06:04
// Design Name: 
// Module Name: data_latency
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


module data_latency(
    input CLK,
    input [31:0] in_data,
    output reg [31:0] out_data
    );
    
    initial out_data <= 0;

    always @(negedge CLK) begin
        out_data = in_data;
    end
    
endmodule

