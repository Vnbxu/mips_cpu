`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/09 10:58:01
// Design Name: 
// Module Name: control_unit
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


module control_unit(
        input zero,
        input sign,
        input [5:0] op,
        output reg RegDst,
        output reg RegWre,
        output reg [2:0] ALUOp,
        output reg [1:0] PCSrc,
        output reg ALUSrcA,
        output reg ALUSrcB,
        output reg mRD,
        output reg mWR,
        output reg DBDataSrc,
        output reg ExtSel,
        output reg PCWre,
        output reg InsMemRW
    );
    
    always@(op or zero or sign) begin
        case(op)
            6'b000000: begin    //add
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000110010;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b000;
            end
            6'b000010: begin    //addi
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010110001;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b000;
            end
            6'b000001: begin    //sub
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000110011;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b001;
            end
            6'b010001: begin    //and
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000110010;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b100;
            end
            6'b010000: begin    // andi
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010110000;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b100;
            end
            6'b010010: begin    //ori
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010110001;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b011;
            end
            6'b010011: begin    //or
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000110010;
                PCSrc[1:0] <= 2'b00;
                ALUOp[2:0] <= 3'b011;
            end
            6'b011000: begin    //sll
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b100110010;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b010;
            end
            6'b011100: begin    //slti
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010110001;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b101;
            end
            6'b100110: begin    //sw
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b010010101;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b000;
            end
            6'b100111: begin    //lw
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b011111001;
                PCSrc[1:0] = 2'b00;
                ALUOp[2:0] = 3'b000;
            end
            6'b110000: begin    //beq
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010001;
                PCSrc[1:0] = (zero == 1 ? 2'b01 : 2'b00);
                ALUOp[2:0] = 3'b001;
            end
            6'b110001: begin    //bne
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010001;
                PCSrc[1:0] = (zero == 1 ? 2'b00 : 2'b01);
                ALUOp[2:0] = 3'b001;
            end
            6'b110010: begin    //bltz
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010001;
                PCSrc[1:0] = (sign == 1 ? 2'b01 : 2'b00);
                ALUOp[2:0] = 3'b000;
            end
            6'b111000: begin    //j
                PCWre = 1;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010000;
                PCSrc[1:0] = 2'b10;
                ALUOp[2:0] = 3'b000;
            end
            6'b111111: begin    //halt
                PCWre = 0;
                {ALUSrcA, ALUSrcB, DBDataSrc, RegWre, InsMemRW, mRD, mWR, RegDst, ExtSel} = 9'b000010000;
                PCSrc[1:0] = 2'b11;
                ALUOp[2:0] = 3'b000;
            end
        endcase
    end
    
endmodule