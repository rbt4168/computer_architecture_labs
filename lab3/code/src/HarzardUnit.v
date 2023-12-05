module HarzardUnit (
    input [4:0] ID_Rs1_i,
    input [4:0] ID_Rs2_i,
    input [4:0] EX_Rd_i,
    input EX_MemRead_i,

    input rst_i, clk_i,

    output NoOp_o, Stall_o, PC_Write_o
);
    wire wirex = ((EX_MemRead_i && EX_Rd_i != 5'b0) && ((EX_Rd_i == ID_Rs1_i) || (EX_Rd_i == ID_Rs2_i))) ? 1'b1 : 1'b0;
    assign NoOp_o = wirex;
    assign Stall_o = wirex;
    assign PC_Write_o = ~wirex;
endmodule