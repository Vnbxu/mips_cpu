`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/11 10:37:47
// Design Name: 
// Module Name: test_multi_cycle_cpu
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


module test_multi_cycle_cpu();
    //input
    reg CLK;
    reg RST;

    //output
    wire [31:0] curPC;
    wire [31:0] nextPC;
    wire [31:0] ins; 
    wire [5:0] op;
    wire [4:0] rs; 
    wire [4:0] rt; 
    wire [4:0] rd;
    wire [31:0] IR_out; 
    wire [31:0] ADR_out; 
    wire [31:0] BDR_out; 
    wire [31:0] ALUoutDR_out; 
    wire [31:0] DBDR_out;

    cpu uut(.CLK(CLK),
            .RST(RST),
            .curPC(curPC),
            .nextPC(nextPC),
            .ins(ins),
            .op(op),
            .rs(rs),
            .rt(rt),
            .rd(rd),
            .IR_out(IR_out),
            .ADR_out(ADR_out),
            .BDR_out(BDR_out),
            .ALUoutDR_out(ALUoutDR_out),
            .DBDR_out(DBDR_out)
    );

    initial begin
        CLK = 0;
        RST = 0;
        #50 RST = 1;
        forever #50 CLK = ~CLK;
    end
endmodule
