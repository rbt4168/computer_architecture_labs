module Control
(
    input [6:0] inst_i,
    output [1:0] ALUOp_o,
    output ALUSrc_o, RegWrite_o
);
    assign ALUOp_o = inst_i[5:4];
    assign ALUSrc_o = ~inst_i[5];
    assign RegWrite_o = 1'b1;
endmodule
