module ALU(
    input signed [31:0] Data1, Data2,
    input [2:0] ALUfunc_i,
    output signed [31:0] ALUresult_o
);
    wire [31:0] first={32{ALUfunc_i[2]}};
    wire [31:0] second={32{ALUfunc_i[1]}};
    wire [31:0] third={32{ALUfunc_i[0]}};
    assign ALUresult_o =
        ((~first) & (~second) & (~third)&(Data1+Data2)) |
        ((~first) & (~second) & ( third)&(Data1<<Data2)) |
        ((~first) & ( second) & (~third)&(Data1^Data2)) |
        ((~first) & ( second) & ( third)&(Data1&Data2)) |
        (( first) & (~second) & (~third)&(Data1*Data2)) |
        (( first) & (~second) & ( third)&(Data1-Data2)) |
        (( first) & ( second) & (~third)&(Data1+Data2)) |
        (( first) & ( second) & ( third)&(Data1>>>Data2[4:0]));
endmodule