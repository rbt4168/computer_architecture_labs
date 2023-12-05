module IFID (
    input [31:0] pc_i,
    output [31:0] pc_o,

    input [31:0] Inst_i,
    output [31:0] Inst_o,
    
    input flush, stall,

    input rst_i,
    input clk_i
);

reg [31:0] pc_s;
reg [31:0] Inst_s;

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        pc_s <= 32'b0;
        Inst_s <= 32'b0;
    end else begin
        if (flush == 1'b1) begin
            pc_s <= 32'b0;
            Inst_s <= 32'b0;
        end else if(stall == 1'b1) begin
            pc_s <= pc_s;
            Inst_s <= Inst_s;
        end else begin
            pc_s <= pc_i;
            Inst_s <= Inst_i;
        end
    end
end

assign pc_o = pc_s;
assign Inst_o = Inst_s;

endmodule