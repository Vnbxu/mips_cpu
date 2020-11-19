`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 20:18:10
// Design Name: 
// Module Name: cpu
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


module cpu(
        input CLK,
        input Reset,
        output [5:0] op,
        output [31:0] ReadData1,
        output [31:0] ReadData2,
        output [31:0] curPC,
        output [31:0] nextPC,
        output [31:0] ALUresult,
        output [31:0] instruction
    );
    
    wire [4:0] rs;
    wire [4:0] rt;
    wire [4:0] rd;
    wire [15:0] immediate;
    wire [25:0] addr;
    wire [31:0] extended;
    wire [4:0] sa;
    wire [31:0] DataOut;
    wire [31:0] DB;

    //control_unit
    wire PCWre, InsMemRW, RegDst, RegWre, ALUSrcA, ALUSrcB, mRD, mWR, DBDataSrc, ExtSel;
    wire [2:0] ALUOp;
    wire [1:0] PCSrc;
    wire ALU_zero, ALU_sign;

    pc_adder pc_adder(.CLK(CLK),
                      .Reset(Reset),
                      .PCSrc(PCSrc),
                      .immediate(extended),
                      .addr(addr),
                      .curPC(curPC),
                      .nextPC(nextPC)
    );

    pc pc(.CLK(CLK),
          .Reset(Reset),
          .PCWre(PCWre),
          .PCSrc(PCSrc),
          .nextPC(nextPC),
          .curPC(curPC)
    );

    ins_mem ins_mem(.IAddr(curPC),
                    .InsMemRW(InsMemRW),
                    .IDataOut(instruction)
    );    

    ins_seg ins_seg(.instruction(instruction),
                    .op(op),
                    .rs(rs),
                    .rt(rt),
                    .rd(rd),
                    .sa(sa),
                    .immediate(immediate),
                    .addr(addr)
    );

    control_unit control_unit(.zero(ALU_zero),
                              .sign(ALU_sign),
                              .op(op),
                              .RegDst(RegDst),
                              .RegWre(RegWre),
                              .ALUOp(ALUOp),
                              .PCSrc(PCSrc),
                              .ALUSrcA(ALUSrcA),
                              .ALUSrcB(ALUSrcB),
                              .mRD(mRD),
                              .mWR(mWR),
                              .DBDataSrc(DBDataSrc),
                              .ExtSel(ExtSel),
                              .PCWre(PCWre),
                              .InsMemRW(InsMemRW)
    );

    register_file register_file(.CLK(CLK),
                                .RegWre(RegWre),
                                .ReadReg1(rs),
                                .ReadReg2(rt),
                                .WriteReg(RegDst ? rd : rt),
                                .WriteData(DB),
                                .ReadData1(ReadData1),
                                .ReadData2(ReadData2)
    );

    alu alu(.ALUSrcA(ALUSrcA),
            .ALUSrcB(ALUSrcB),
            .ReadData1(ReadData1),
            .ReadData2(ReadData2),
            .sa(sa),
            .extend(extended),
            .ALUOp(ALUOp), 
            .sign(ALU_sign),
            .zero(ALU_zero),
            .result(ALUresult)
    );

    data_mem data_mem(.mRD(mRD),
                      .mWR(mWR),
                      .CLK(CLK),
                      .DBDataSrc(DBDataSrc),
                      .DAddr(ALUresult),
                      .DataIn(ReadData2),
                      .DataOut(DataOut),
                      .DB(DB)
    );

    sign_zero_extend sign_zero_extend(.immediate(immediate),
                                      .ExtSel(ExtSel),
                                      .extendImmediate(extended)
    );
endmodule
