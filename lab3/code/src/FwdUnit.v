module FwdUnit(
    input MEM_RegWrite_i,
    input [4:0] MEM_Rd_i,

    input WB_RegWrite_i,
    input [4:0] WB_Rd_i,

    input [4:0] EX_Rs1_i,
    input [4:0] EX_Rs2_i,

    output [1:0] FwdA_o,
    output [1:0] FwdB_o
);

assign FwdA_o = (MEM_RegWrite_i && ( MEM_Rd_i == EX_Rs1_i ) && ( MEM_Rd_i != 5'b0 ) ) ? 2'b10 :
                (WB_RegWrite_i && ( WB_Rd_i == EX_Rs1_i ) && ( WB_Rd_i != 5'b0 ) ) ? 2'b01 :
                 2'b00;

assign FwdB_o = (MEM_RegWrite_i && ( MEM_Rd_i == EX_Rs2_i ) && ( MEM_Rd_i != 5'b0 ) ) ? 2'b10 :
                (WB_RegWrite_i && ( WB_Rd_i == EX_Rs2_i ) && ( WB_Rd_i != 5'b0 ) ) ? 2'b01 :
                 2'b00;

endmodule