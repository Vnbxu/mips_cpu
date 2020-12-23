`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 11:14:50
// Design Name: 
// Module Name: reg_file
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


module reg_file(
        input CLK,
        input RegWre,
        input [1:0] RegDst,
        input [4:0] rt,
        input [4:0] rd,
        input [4:0] ReadReg1,
        input [4:0] ReadReg2,
        input [31:0] WriteData,
        output reg [31:0] ReadData1,
        output reg [31:0] ReadData2
    );
    
    reg [4:0] WriteReg;
    reg [31:0] regFile[0:31];
    integer i;
    initial begin
        for(i = 0; i < 32; i = i + 1) regFile[i] <= 0;
    end 
    
    always@(ReadReg1 or ReadReg2) begin
        ReadData1 = regFile[ReadReg1];
        ReadData2 = regFile[ReadReg2];
    end
    
    always@(RegDst) begin
        if(RegDst == 2'b00) WriteReg = 5'b11111;
        else if(RegDst == 2'b01) WriteReg = rt;
        else if(RegDst == 2'b10) WriteReg = rd;
        else WriteReg = 5'bzzzzz;
    end
  
    always@(posedge CLK) begin
        if(WriteReg!=0 && RegWre) regFile[WriteReg] <= WriteData;
    end
endmodule
