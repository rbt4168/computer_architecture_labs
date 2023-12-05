module Sign_Extend(
    input [11:0] imm_i,
    output [31:0] ext_o
);
    assign ext_o[11:0] = imm_i[11:0];
    assign ext_o[31:12] = {20{imm_i[11]}};
endmodule