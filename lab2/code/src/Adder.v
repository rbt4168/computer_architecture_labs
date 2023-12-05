module Adder (
    input [31:0] valueA_i, valueB_i,
    output [31:0] value_o
);
    assign value_o = valueA_i + valueB_i;
endmodule