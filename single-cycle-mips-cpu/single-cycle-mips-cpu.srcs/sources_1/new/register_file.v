`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/08 20:47:03
// Design Name: 
// Module Name: register_file
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


module register_file(
        input CLK,
        input RegWre,
        input [4:0] ReadReg1,
        input [4:0] ReadReg2,
        input [4:0] WriteReg,
        input [31:0] WriteData,
        output [31:0] ReadData1,
        output [31:0] ReadData2
    );
    
    reg [31:0] regFile[0:31];
    integer i;
    initial begin
        for(i = 0; i < 32; i = i + 1) regFile[i] <= 0;
    end 
    
    assign ReadData1 = regFile[ReadReg1];
    assign ReadData2 = regFile[ReadReg2];
  
    always@(negedge CLK) begin
        if(WriteReg!=0 && RegWre) regFile[WriteReg] <= WriteData;
    end
endmodule
