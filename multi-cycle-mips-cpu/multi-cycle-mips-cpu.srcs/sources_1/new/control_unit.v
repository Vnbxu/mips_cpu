`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 12:13:30
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
        input CLK,
        input RST,
        input zero,
        input sign,
        input [5:0] op,
        output reg WrRegDSrc,
        output reg [1:0] RegDst,
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
        output reg InsMemRW,
        output reg IRWre
    );

    reg [2:0] state;
    parameter [5:0] ADD = 6'b000000, SUB = 6'b000001, ADDI = 6'b000010, AND = 6'b010000, ANDI = 6'b010001, ORI = 6'b010010, XORI = 6'b010011, SLL = 6'b011000, SLTI = 6'b100110, SLT = 6'b100111, SW = 6'b110000, LW = 6'b110001, BEQ = 6'b110100, BNE = 6'b110101, BLTZ = 6'b110110, J = 6'b111000, JR = 6'b111001, JAL = 6'b111010, HALT = 6'b111111; 
    initial begin
        PCWre = 0;  
        InsMemRW = 0;  
        IRWre = 0;  
        RegWre = 0;
        ExtSel = 0;  
        PCSrc = 2'b00;  
        RegDst = 2'b11;
        ALUOp = 3'b000;  
        ExtSel = 0;
        WrRegDSrc = 0;
        ALUSrcA = 0;
        ALUSrcB = 0;
        mRD = 0;
        mWR = 0;
        DBDataSrc = 0;
    end

    always@(posedge CLK or negedge RST) begin
        if(RST == 0) begin
            state = 3'b000;
            PCWre = 0;
            IRWre = 0;
        end
        else begin
            // next state
            case(state)
                3'b000: state = 3'b001;
                3'b001: begin
                    if(op == ADD || op == SUB || op == ADDI || op == AND || op == ANDI || op == ORI || op == XORI || op == SLL || op == SLT || op == SLTI) state = 3'b110;
                    else if(op == BEQ || op == BNE || op == BLTZ) state = 3'b101;
                    else if(op == SW || op == LW) state = 3'b010;
                    else if(op == J || op == JAL || op == JR || op == HALT) state = 3'b000;
                end
                3'b110: state = 3'b111;
                3'b111, 3'b101, 3'b100: state = 3'b000;
                3'b010: state = 3'b011;
                3'b011: begin
                    if(op == LW) state = 3'b100;
                    else state = 3'b000;
                end
            endcase
        end
    end

    //PCWre, IRWre
    always@(negedge CLK) begin
        if(state == 3'b000) IRWre = 1;
        else IRWre = 0;
        case(state)
            3'b111, 3'b101, 3'b100: PCWre = 1;  
            3'b011: PCWre = (op == SW ? 1 : 0);  //sw
            3'b001: PCWre = ((op == J || op == JAL || op == JR) ? 1 : 0);
            default: PCWre = 0;
        endcase
    end

    always@(op or zero or sign or state) begin
        //ALUSrcA, ALUSrcB
        ALUSrcA = (op == SLL ? 1 : 0);
        if(op == ADDI || op == ANDI || op == ORI ||op == XORI || op == SLTI || op == SW || op == LW) ALUSrcB = 1;
        else ALUSrcB = 0;

        //RegWre
        if(((state == 3'b111 || state == 3'b100) && (op == ADD || op == SUB || op == ADDI || op ==AND || op ==ANDI || op ==ORI || op ==XORI || op ==SLL || op ==SLT || op ==SLTI || op ==LW)) || (state == 3'b001 && op ==JAL)) RegWre = 1;
        else RegWre = 0;

        //DBDataSrc, WrRegDSrc, InsMemRW, mRD, mWR, ExtSel
        DBDataSrc = (op == LW ? 1 : 0);
        WrRegDSrc = (state == 3'b001 && op == JAL) ? 0: 1;
        InsMemRW = 1;
        mRD = (op == LW ? 1 : 0);
        mWR = (state == 3'b011 && op == SW) ? 1 : 0;
        ExtSel = (op == ADDI || op == ANDI || op ==SLTI || op == SW || op ==LW || op == BEQ || op ==BNE || op ==BLTZ) ? 1 : 0;
        
        //PCSrc
        if(op == J || op== JAL) PCSrc = 2'b11;
        else if(op == JR) PCSrc = 2'b10;
        else if(op ==BEQ && zero == 1) PCSrc = 2'b01;
        else if(op == BNE && zero == 0) PCSrc = 2'b01;
        else if(op == BLTZ && sign == 1) PCSrc = 2'b01;
        else PCSrc = 2'b00;

        //RegDst
        if(state == 3'b001 && op == JAL) RegDst = 2'b00;
        else if((state == 3'b111 || state == 3'b100) && (op == ADDI || op == ANDI || op == ORI || op == XORI || op == SLTI || op == LW)) RegDst = 2'b01;
        else if((state == 3'b111 || state == 3'b100) && (op == ADD || op == SUB || op == AND || op == SLL || op == SLT)) RegDst = 2'b10;
        else RegDst = 2'b11;

        //ALUOp
        case(op)
            ADD, ADDI, SW, LW, BLTZ: ALUOp = 3'b000;
            SUB, BEQ, BNE: ALUOp = 3'b001; 
            SLL: ALUOp = 3'b010; 
            ORI: ALUOp = 3'b011; 
            AND, ANDI: ALUOp = 3'b100;   
            SLTI, SLT: ALUOp = 3'b110;   
            XORI: ALUOp = 3'b111; 
            default: ALUOp = 3'b000;    //j, jr, jal, halt
        endcase
    end
endmodule




