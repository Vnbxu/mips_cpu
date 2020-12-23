`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 11:19:36
// Design Name: 
// Module Name: data_mem
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


module data_mem(
        input CLK,
        input mRD,
        input mWR,
        input DBDataSrc,
        input [31:0] ALUResult,
        input [31:0] DAddr,
        input [31:0] DataIn,
        output reg[31:0] DataOut,
        output reg[31:0] DB
    );
    
    reg [7:0] ram[0:127];
    integer i;
    initial begin
        DB <= 0;
        DataOut <= 0;
        for(i = 0;i < 128; i = i + 1) ram[i] <= 0;
    end
    
    always@(*) begin
        DataOut[7:0] = mRD ? ram[DAddr + 3] : 8'bz;
        DataOut[15:8] = mRD ? ram[DAddr + 2] : 8'bz;     
        DataOut[23:16] = mRD ? ram[DAddr + 1] : 8'bz;     
        DataOut[31:24] = mRD ? ram[DAddr] : 8'bz;
        DB = DBDataSrc ? DataOut : ALUResult;
    end
     
    always@(negedge CLK) begin   
        if(mWR == 1) begin
            ram[DAddr + 3] = DataIn[7:0];   
            ram[DAddr + 2] = DataIn[15:8];  
            ram[DAddr + 1] = DataIn[23:16]; 
            ram[DAddr] = DataIn[31:24];    
        end
    end
endmodule
