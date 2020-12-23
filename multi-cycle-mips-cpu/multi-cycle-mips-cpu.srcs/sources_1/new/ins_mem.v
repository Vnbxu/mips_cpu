`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/07 11:13:41
// Design Name: 
// Module Name: ins_mem
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


module ins_mem(
        input InsMemRW,
        input [31:0] IAddr,
        output reg[31:0] IDataOut
    );
    
    reg [7:0] rom[0:127];
    initial $readmemb("C:\\Users\\Administrator\\Desktop\\multi-cycle-mips-cpu\\test_data.txt", rom);
    
    always@(IAddr or InsMemRW) begin
        if(InsMemRW) begin
            IDataOut[7:0] = rom[IAddr + 3];
            IDataOut[15:8] = rom[IAddr + 2];
            IDataOut[23:16] = rom[IAddr + 1];
            IDataOut[31:24] = rom[IAddr];
        end 
    end
endmodule
