`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 11:18:14
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
    input RST,
    output [31:0] curPC,
    output [31:0] nextPC,
    output [31:0] ins,
    output [5:0] op,
    output [4:0] rs, 
    output [4:0] rt, 
    output [4:0] rd,
    output [31:0] IR_out, 
    output [31:0] ADR_out, 
    output [31:0] BDR_out, 
    output [31:0] ALUoutDR_out, 
    output [31:0] DBDR_out
    );
    //data path
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;
    wire [31:0] ALUResult; 
    wire [31:0] DB;
    wire [31:0] DataOut;
    wire zero, sign;
    wire [15:0] immediate;
    wire [25:0] addr;
    wire [31:0] extended;
    wire [4:0] sa;

    //control signal
    wire PCWre, IRWre, InsMemRW, WrRegDSrc, RegWre, ALUSrcA, ALUSrcB, mRD, mWR, DBDataSrc, ExtSel;
    wire [2:0] ALUOp;
    wire [1:0] RegDst;
    wire [1:0] PCSrc;

    pc_adder pc_adder(.CLK(CLK),
                      .Reset(RST),
                      .ReadData(ReadData1),
                      .PCSrc(PCSrc),
                      .immediate(extended),
                      .addr(addr),
                      .curPC(curPC),
                      .nextPC(nextPC)
    );

    pc pc(.CLK(CLK),
          .Reset(RST),
          .PCWre(PCWre),
          .PCSrc(PCSrc),
          .nextPC(nextPC),
          .curPC(curPC)
    );

    ins_mem ins_mem(.IAddr(curPC),
                    .InsMemRW(InsMemRW),
                    .IDataOut(ins)
    );    

    IR IR(.CLK(CLK),
          .IRWre(IRWre),
          .in_data(ins),
          .out_data(IR_out)
    );

    ins_seg ins_seg(.ins(IR_out),
                    .op(op),
                    .rs(rs),
                    .rt(rt),
                    .rd(rd),
                    .sa(sa),
                    .immediate(immediate),
                    .addr(addr)
    );

    control_unit control_unit(.CLK(CLK),
                              .RST(RST),
                              .zero(zero),
                              .sign(sign),
                              .op(op),
                              .WrRegDSrc(WrRegDSrc),
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
                              .InsMemRW(InsMemRW),
                              .IRWre(IRWre)
    );

    reg_file reg_file(.CLK(CLK),
                      .RegWre(RegWre),
                      .RegDst(RegDst),
                      .rt(rt),
                      .rd(rd),
                      .ReadReg1(rs),
                      .ReadReg2(rt),
                      .WriteData(WrRegDSrc == 0 ? curPC + 4 : DBDR_out),
                      .ReadData1(ReadData1),
                      .ReadData2(ReadData2)
    );

    data_latency ADR(.CLK(CLK),
                     .in_data(ReadData1),
                     .out_data(ADR_out)
    );
    
    data_latency BDR(.CLK(CLK),
                     .in_data(ReadData2),
                     .out_data(BDR_out)
    );


    alu alu(.ALUSrcA(ALUSrcA),
            .ALUSrcB(ALUSrcB),
            .ReadData1(ReadData1),
            .ReadData2(ReadData2),
            .sa(sa),
            .extended(extended),
            .ALUOp(ALUOp), 
            .sign(sign),
            .zero(zero),
            .result(ALUResult)
    );

    data_latency ALUoutDR(.CLK(CLK),
                          .in_data(ALUResult),
                          .out_data(ALUoutDR_out)
    );

    data_mem data_mem(.mRD(mRD),
                      .mWR(mWR),
                      .CLK(CLK),
                      .DBDataSrc(DBDataSrc),
                      .ALUResult(ALUResult),
                      .DAddr(ALUoutDR_out),
                      .DataIn(BDR_out),
                      .DataOut(DataOut),
                      .DB(DB)
    );

    data_latency DBDR(.CLK(CLK),
                     .in_data(DB),
                     .out_data(DBDR_out)
    );

    sign_zero_extend sign_zero_extend(.immediate(immediate),
                                      .ExtSel(ExtSel),
                                      .extendImmediate(extended)
    );

endmodule
