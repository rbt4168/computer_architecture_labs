module ImmGen(
    input [31:0] Inst_i,
    output reg [31:0] ImmGen_o
);

always @(*) begin
    if (Inst_i == 32'b0) begin
        ImmGen_o = 32'b0;
    end else if (Inst_i[6:0] == 7'b0010011) begin
        ImmGen_o[31:12] = {20{Inst_i[31]}};
        ImmGen_o[11:0] = Inst_i[31:20];
    end else if (Inst_i[6:0] == 7'b0000011) begin
        ImmGen_o[31:12] = {20{Inst_i[31]}};
        ImmGen_o[11:0] = Inst_i[31:20];
    end else if (Inst_i[6:0] == 7'b0100011) begin
        ImmGen_o[31:12] = {20{Inst_i[31]}};
        ImmGen_o[11:5] = Inst_i[31:25];
        ImmGen_o[4:0] = Inst_i[11:7];
    end else if (Inst_i[6:0] == 7'b1100011) begin
        ImmGen_o[31:12] = {20{Inst_i[31]}};
        ImmGen_o[11] = Inst_i[31];
        ImmGen_o[10] = Inst_i[7];
        ImmGen_o[9:4] = Inst_i[30:25];
        ImmGen_o[3:0] = Inst_i[11:8];
    end else begin
        ImmGen_o = 32'b0;
    end
end
endmodule