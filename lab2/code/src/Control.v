module Control
(
    input [6:0] Inst_i,
    input rst_i, clk_i,

    input NoOp,

    output reg [1:0] ALUOp_o,
    output reg ALUSrc_o, RegWrite_o,

    output reg Branch_o,
    output reg MemtoReg, MemRead, MemWrite
);

always @(*) begin
    if(~rst_i) begin
        // No operation
        ALUOp_o <= 2'b00;
        ALUSrc_o <= 1'b0;
        RegWrite_o <= 1'b0;
        Branch_o <= 1'b0;
        MemtoReg <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
    end else if (NoOp == 1'b1) begin
        // No operation
        ALUOp_o <= 2'b00;
        ALUSrc_o <= 1'b0;
        RegWrite_o <= 1'b0;
        Branch_o <= 1'b0;
        MemtoReg <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
    end else if (Inst_i[6:0] == 7'b0) begin
        ALUOp_o <= 2'b00;
        ALUSrc_o <= 1'b0;
        RegWrite_o <= 1'b0;
        Branch_o <= 1'b0;
        MemtoReg <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
    end else if (Inst_i[6:4] == 3'b011) begin
        // rs1 and rs2
        ALUOp_o = 2'b11;
        ALUSrc_o = 1'b0;
        RegWrite_o = 1'b1;
        Branch_o = 1'b0;
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
    end else if (Inst_i[6:4] == 3'b001) begin
        // rs1 and imm
        ALUOp_o = 2'b01;
        ALUSrc_o = 1'b1;
        RegWrite_o = 1'b1;
        Branch_o = 1'b0;
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
    end else if (Inst_i[6:4] == 3'b000) begin
        // load rd imm(rs1)
        ALUOp_o = 2'b00;
        ALUSrc_o = 1'b1;
        RegWrite_o = 1'b1;
        Branch_o = 1'b0;
        MemtoReg = 1'b1;
        MemRead = 1'b1;
        MemWrite = 1'b0;
    end else if (Inst_i[6:4] == 3'b010) begin
        // save rs2 imm(rs1)
        ALUOp_o = 2'b00;
        ALUSrc_o = 1'b1;
        RegWrite_o = 1'b0;
        Branch_o = 1'b0;
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b1;
    end else if (Inst_i[6:4] == 3'b110) begin
        // branch
        ALUOp_o = 2'b00;
        ALUSrc_o = 1'b0;
        RegWrite_o = 1'b0;
        Branch_o = 1'b1;
        MemtoReg = 1'b0;
        MemRead = 1'b0;
        MemWrite = 1'b0;
    end else begin
        ALUOp_o <= 2'b00;
        ALUSrc_o <= 1'b0;
        RegWrite_o <= 1'b0;
        Branch_o <= 1'b0;
        MemtoReg <= 1'b0;
        MemRead <= 1'b0;
        MemWrite <= 1'b0;
    end
end
endmodule
