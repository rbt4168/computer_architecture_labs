module MUX32 (
    input [31:0] zero, one,
    input select_bit,
    output [31:0] out
);
    assign out = ( select_bit == 1'b0 ) ? zero : one;
endmodule