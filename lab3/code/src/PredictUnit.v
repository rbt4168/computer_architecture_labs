module PredictUnit (
    input Branch_i, Decide_i, Eq_i,
    output reg IFID_flush_o, IDEX_flush_o, recover_o,
    output predict_o,
    input rst_i, clk_i
);

reg [1:0] status_value;
assign predict_o = status_value[1];

always @(posedge clk_i) begin
    // status
    if(Branch_i) begin
        if (status_value == 2'b11) begin
            if(Eq_i) begin
                status_value <= 2'b11;
            end else begin
                status_value <= 2'b10;
            end
        end else if (status_value == 2'b10) begin
            if(Eq_i) begin
                status_value <= 2'b11;
            end else begin
                status_value <= 2'b01;
            end
        end else if(status_value == 2'b01) begin
            if(Eq_i) begin
                status_value <= 2'b10;
            end else begin
                status_value <= 2'b00;
            end
        end else begin
            if(Eq_i) begin
                status_value <= 2'b01;
            end else begin
                status_value <= 2'b00;
            end
        end
    end
end

always @(*) begin
    if(~rst_i) begin
        IFID_flush_o <= 1'b0;
        IDEX_flush_o <= 1'b0;
        recover_o <= 1'b0;
        status_value <= 2'b11;
    end
    if(Branch_i) begin
        if(Decide_i == Eq_i) begin
            // hit
            IFID_flush_o <= 1'b0;
            IDEX_flush_o <= 1'b0;
            recover_o <= 1'b0;
        end else begin
            // recover
            IFID_flush_o <= 1'b1;
            IDEX_flush_o <= 1'b1;
            recover_o <= 1'b1;
        end
    end else begin
        IFID_flush_o <= 1'b0;
        IDEX_flush_o <= 1'b0;
        recover_o <= 1'b0;
    end
end

endmodule