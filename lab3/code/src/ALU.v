module ALU(
    input signed [31:0] Data1, Data2,
    input [2:0] ALUfunc_i,
    input Branch_i,
    output [31:0] data_o,
    output eq
);
    
    wire [31:0] first  = (Branch_i == 1'b0) ? {32{ALUfunc_i[2]}} : 32'b11111111111111111111111111111111;
    wire [31:0] second = (Branch_i == 1'b0) ? {32{ALUfunc_i[1]}} : 32'b00000000000000000000000000000000;
    wire [31:0] third  = (Branch_i == 1'b0) ? {32{ALUfunc_i[0]}} : 32'b11111111111111111111111111111111;
    
    assign data_o =
        ((~first) & (~second) & (~third)&(Data1+Data2)) |
        ((~first) & (~second) & ( third)&(Data1<<Data2)) |
        ((~first) & ( second) & (~third)&(Data1^Data2)) |
        ((~first) & ( second) & ( third)&(Data1&Data2)) |
        (( first) & (~second) & (~third)&(Data1*Data2)) |
        (( first) & (~second) & ( third)&(Data1-Data2)) |
        (( first) & ( second) & (~third)&(Data1+Data2)) |
        (( first) & ( second) & ( third)&(Data1>>>Data2[4:0]));
    

    assign eq = (Data1 == Data2) ? 1'b1 : 1'b0;
    
endmodule