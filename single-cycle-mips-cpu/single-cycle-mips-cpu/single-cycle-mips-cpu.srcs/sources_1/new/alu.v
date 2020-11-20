`timescale 1ns / 1ps

module alu(
    input [2:0] ALUOp,
    input ALUSrcA,
    input ALUSrcB,
    input [31:0] ReadData1,
    input [4:0] sa,
    input [31:0] ReadData2,
    input [31:0] extend,
    output reg sign,
    output reg zero,
    output reg[31:0] result
    );
    
    reg [31:0] A;
    reg [31:0] B;

    always@(*) begin
        // MUX
        A = (ALUSrcA == 0) ? ReadData1 : sa;
        B = (ALUSrcB == 0) ? ReadData2 : extend;
        case(ALUOp)
            3'b000: result = A + B;
            3'b001: result = A - B;
            3'b010: result = B << A;
            3'b011: result = A | B;
            3'b100: result = A & B;
            3'b101: result = (A < B) ? 1 : 0;
            3'b110: result = ((A < B) && (A[31] == B[31]))||(((A[31] == 1) && (B[31] == 0)) ? 1 : 0);
            3'b111: result = A ^ B;
        endcase
        zero = (result == 0) ? 1 : 0;
        sign = result[31];
    end
endmodule