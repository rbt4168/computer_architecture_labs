module MUX32_4 (
    input [31:0] zero_zero, zero_one,
    input [31:0] one_zero, one_one,
    input [1:0] select_bit,
    output [31:0] out
);
    assign out = 
        ( select_bit == 2'b00 ) ? zero_zero : 
        ( select_bit == 2'b01 ) ? zero_one : 
        ( select_bit == 2'b10 ) ? one_zero : 
        ( select_bit == 2'b11 ) ? one_one : 32'b0 ;
endmodule