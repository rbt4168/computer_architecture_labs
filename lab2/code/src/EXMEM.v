module EXMEM (
    input RegWrite_i,
    input MemtoReg_i,
    input MemRead_i,
    input MemWrite_i,

    input [31:0] ALUresult_i,
    input [31:0] ReadData2_i,
    input [31:0] Inst_i,

    output RegWrite_o,
    output MemtoReg_o,
    output MemRead_o,
    output MemWrite_o,

    output [31:0] ALUresult_o,
    output [31:0] ReadData2_o,
    output [31:0] Inst_o,

    input rst_i,
    input clk_i
);

reg RegWrite_s;
reg MemtoReg_s;
reg MemRead_s;
reg MemWrite_s;

reg [31:0] ALUresult_s;
reg [31:0] ReadData2_s;
reg [31:0] Inst_s;

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        RegWrite_s <= 1'b0;
        MemtoReg_s <= 1'b0;
        MemRead_s <= 1'b0;
        MemWrite_s <= 1'b0;
        
        ALUresult_s <= 32'b0;
        ReadData2_s <= 32'b0;
        Inst_s <= 32'b0;
    end
    else begin
        RegWrite_s <= RegWrite_i;
        MemtoReg_s <= MemtoReg_i;
        MemRead_s <= MemRead_i;
        MemWrite_s <= MemWrite_i;
        
        ALUresult_s <= ALUresult_i;
        ReadData2_s <= ReadData2_i;
        Inst_s <= Inst_i;
    end
end

assign RegWrite_o = RegWrite_s;
assign MemtoReg_o = MemtoReg_s;
assign MemRead_o = MemRead_s;
assign MemWrite_o = MemWrite_s;

assign ALUresult_o = ALUresult_s;
assign ReadData2_o = ReadData2_s;
assign Inst_o = Inst_s;

endmodule