module LeftShifter (
    input [31:0] value_i,
    output [31:0] value_o
);
    assign value_o = value_i << 1;
endmodule

