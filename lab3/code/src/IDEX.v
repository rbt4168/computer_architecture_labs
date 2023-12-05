module IDEX (
    input RegWrite_i,
    input MemtoReg_i,
    input MemRead_i,
    input MemWrite_i,
    input [1:0] ALUOp_i,
    input ALUSrc_i,
    input [31:0] ReadData1_i,
    input [31:0] ReadData2_i,
    input [31:0] ImmGen_i,
    input [31:0] Inst_i,

    output RegWrite_o,
    output MemtoReg_o,
    output MemRead_o,
    output MemWrite_o,
    output [1:0] ALUOp_o,
    output ALUSrc_o,
    output [31:0] ReadData1_o,
    output [31:0] ReadData2_o,
    output [31:0] ImmGen_o,
    output [31:0] Inst_o,

    input Branch_i,
    output Branch_o,
    input Decide_i,
    output Decide_o,
    input [31:0] SEPC_i,
    output [31:0] SEPC_o,
    input flush_i,

    input rst_i,
    input clk_i
);

reg RegWrite_s;
reg MemtoReg_s;
reg MemRead_s;
reg MemWrite_s;
reg [1:0] ALUOp_s;
reg ALUSrc_s;
reg [31:0] ReadData1_s;
reg [31:0] ReadData2_s;
reg [31:0] ImmGen_s;
reg [31:0] Inst_s;
reg Branch_s;
reg [31:0] SEPC_s;
reg Decide_s;

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        RegWrite_s <= 1'b0;
        MemtoReg_s <= 1'b0;
        MemRead_s <= 1'b0;
        MemWrite_s <= 1'b0;
        ALUOp_s <= 2'b0;
        ALUSrc_s <= 1'b0;
        ReadData1_s <= 32'b0;
        ReadData2_s <= 32'b0;
        ImmGen_s <= 32'b0;
        Inst_s <= 32'b0;
        Branch_s <= 1'b0;
        SEPC_s <= 32'b0;
        Decide_s <= 1'b0;
    end else begin
        if (flush_i == 1'b1) begin
            RegWrite_s <= 1'b0;
            MemtoReg_s <= 1'b0;
            MemRead_s <= 1'b0;
            MemWrite_s <= 1'b0;
            ALUOp_s <= 2'b0;
            ALUSrc_s <= 1'b0;
            ReadData1_s <= 32'b0;
            ReadData2_s <= 32'b0;
            ImmGen_s <= 32'b0;
            Inst_s <= 32'b0;
            Branch_s <= 1'b0;
            SEPC_s <= 32'b0;
            Decide_s <= 1'b0;
        end else begin
            RegWrite_s <= RegWrite_i;
            MemtoReg_s <= MemtoReg_i;
            MemRead_s <= MemRead_i;
            MemWrite_s <= MemWrite_i;
            ALUOp_s <= ALUOp_i;
            ALUSrc_s <= ALUSrc_i;
            ReadData1_s <= ReadData1_i;
            ReadData2_s <= ReadData2_i;
            ImmGen_s <= ImmGen_i;
            Inst_s <= Inst_i;
            Branch_s <= Branch_i;
            if (Branch_i) begin
                SEPC_s <= SEPC_i;
            end else begin
                SEPC_s <= SEPC_s;
            end
            Decide_s <= Decide_i;
        end
    end
end

assign RegWrite_o = RegWrite_s;
assign MemtoReg_o = MemtoReg_s;
assign MemRead_o = MemRead_s;
assign MemWrite_o = MemWrite_s;
assign ALUOp_o = ALUOp_s;
assign ALUSrc_o = ALUSrc_s;
assign ReadData1_o = ReadData1_s;
assign ReadData2_o = ReadData2_s;
assign ImmGen_o = ImmGen_s;
assign Inst_o = Inst_s;
assign Branch_o = Branch_s;
assign Decide_o = Decide_s;
assign SEPC_o = SEPC_s;

endmodule