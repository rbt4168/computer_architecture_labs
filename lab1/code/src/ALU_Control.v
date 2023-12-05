module ALU_Control(
    input [1:0] ALUop_i,
    input [2:0] func3,
    input [6:0] func7,
    output [2:0] ALUfunc_o
);
    wire Rtype=ALUop_i[1];
    wire Itype=!ALUop_i[1];
    assign ALUfunc_o[0] = (Rtype&func3[0])|(Rtype&func7[5])|(Itype&func3[2]);
    assign ALUfunc_o[1] = (Rtype&func3[2])|(Itype);
    assign ALUfunc_o[2] = (Rtype&func7[0])|(Rtype&func7[5])|(Itype);
endmodule