`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/17 20:15:37
// Design Name: 
// Module Name: test_single_cycle_cpu
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


module test_single_cycle_cpu();
    // Input
    reg CLK;
    reg Reset;

    // Output
    wire [31:0] curPC;
    wire [31:0] nextPC;

    wire [5:0] op;

    wire [31:0] ReadData1;
    wire [31:0] ReadData2;  

    wire [31:0] instruction; 
    wire [31:0] ALUresult;

    cpu uut(
        .CLK(CLK),
        .Reset(Reset),
        .op(op),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .curPC(curPC),
        .nextPC(nextPC),
        .ALUresult(ALUresult),
        .instruction(instruction)
    );
    
    initial begin
        CLK = 0;
        Reset = 0;
        #50;
        begin 
            Reset=1;
            CLK=1;
        end
        forever #50 CLK=~CLK;
    end
     

endmodule
