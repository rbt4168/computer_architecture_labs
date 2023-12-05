module IFID (
    input [31:0] pc_i,
    output [31:0] pc_o,

    input [31:0] Inst_i,
    output [31:0] Inst_o,

    input [31:0] pcnxt_i,
    output [31:0] pcnxt_o,
    
    input flush_i, stall_i,

    input rst_i,
    input clk_i
);

reg [31:0] pc_s;
reg [31:0] Inst_s;

reg [31:0] pcnxt_s;

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_s <= 32'b0;
        Inst_s <= 32'b0;
        pcnxt_s <= 32'b0;
    end else begin
        if (flush_i == 1'b1) begin
            pc_s <= 32'b0;
            Inst_s <= 32'b0;
            pcnxt_s <= 32'b0;
        end else if(stall_i == 1'b1) begin
            pc_s <= pc_s;
            Inst_s <= Inst_s;
            pcnxt_s <= pcnxt_s;
        end else begin
            pc_s <= pc_i;
            Inst_s <= Inst_i;
            pcnxt_s <= pcnxt_i;
        end
    end
end

assign pc_o = pc_s;
assign Inst_o = Inst_s;
assign pcnxt_o = pcnxt_s;

endmodule