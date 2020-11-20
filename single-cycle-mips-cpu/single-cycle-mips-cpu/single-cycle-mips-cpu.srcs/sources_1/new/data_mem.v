module data_mem(
        input CLK,
        input mRD,
        input mWR,
        input DBDataSrc,
        input [31:0] DAddr,
        input [31:0] DataIn,
        output reg[31:0] DataOut,
        output reg[31:0] DB
    );
    
    reg [7:0] ram[0:127];
    integer i;
    initial begin
        DB <= 16'b0;
        DataOut <= 16'b0;
        for(i = 0;i < 128; i = i + 1) ram[i] <= 0;
    end
    
    always@(mRD or DAddr or DBDataSrc) begin
        DataOut[7:0] = mRD ? ram[DAddr + 3] : 8'bz;
        DataOut[15:8] = mRD ? ram[DAddr + 2] : 8'bz;     
        DataOut[23:16] = mRD ? ram[DAddr + 1] : 8'bz;     
        DataOut[31:24] = mRD ? ram[DAddr] : 8'bz;
        DB = DBDataSrc ? DataOut : DAddr;
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
