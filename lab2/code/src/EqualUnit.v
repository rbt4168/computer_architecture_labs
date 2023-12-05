module EqualUnit (
    input [31:0] value_a, value_b,
    output value_o
);
    assign value_o = ( value_a == value_b ) ? 1'b1 : 1'b0;
endmodule