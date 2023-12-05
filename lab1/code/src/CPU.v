module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

wire [31:0] PCnow, PCnext, instr;
wire [31:0] RData1, RData2, ImmData, ALUSrc2, ALUResult;
wire [2:0] ALUfunc;
wire [1:0] ALUop;
wire RegWrite, MUXAlu;

PC PC(
    .clk_i(clk_i), .rst_i(rst_i), .pc_i(PCnext),
    .pc_o(PCnow)
);

Adder Add_PC(
    .pc_i(PCnow),
    .pc_o(PCnext)
);

Instruction_Memory Instruction_Memory(
    .addr_i(PCnow),
    .instr_o(instr)
);

Control Control(
    .inst_i(instr[6:0]) ,
    .ALUOp_o(ALUop), .ALUSrc_o(MUXAlu), .RegWrite_o(RegWrite)
);

Registers Registers(
    .rst_i(rst_i), .clk_i(clk_i),
    .RS1addr_i(instr[19:15]), .RS2addr_i(instr[24:20]),
    .RDaddr_i(instr[11:7]), .RDdata_i(ALUResult),
    .RegWrite_i(RegWrite),
    
    .RS1data_o(RData1), .RS2data_o(RData2)
);

Sign_Extend Sign_Extend(
    .imm_i(instr[31:20]),
    .ext_o(ImmData)
);

MUX32 MUX_ALUSrc(
    .a(RData2), .b(ImmData), .s(MUXAlu),
    .c(ALUSrc2)
);

ALU_Control ALU_Control(
    .ALUop_i(ALUop), .func3(instr[14:12]), .func7(instr[31:25]),
    .ALUfunc_o(ALUfunc)
);

ALU ALU(
    .Data1(RData1), .Data2(ALUSrc2), .ALUfunc_i(ALUfunc),
    .ALUresult_o(ALUResult)
);

endmodule

