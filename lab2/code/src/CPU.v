module CPU
(
    clk_i, 
    rst_i,
);

// Ports
input               clk_i;
input               rst_i;

wire [31:0] IF_PCout, IF_adderout,
            IF_muxout, IF_instr;

wire ID_branchout, ID_equalout, ID_FlushIF;
wire ID_noopout, ID_stallout, ID_PCwrite;
wire [31:0] ID_instr, ID_imm, ID_addertop,
            ID_PCout, ID_adderout, ID_Data1,
            ID_Data2;
wire [1:0] ID_aluop;
wire ID_alusrc, ID_regwrite;
wire ID_memtoreg, ID_memread, ID_memwrite;

wire [1:0] EX_aluop;
wire EX_alusrc, EX_regwrite;
wire EX_memtoreg, EX_memread, EX_memwrite;
wire [31:0] EX_instr, EX_imm, EX_Data1, EX_Data2;
wire [31:0] EX_aluvalue1, EX_muxzero, EX_aluvalue2;
wire [31:0] EX_aluresult;
wire [2:0] EX_alufunc;
wire [1:0] EX_fwdA, EX_fwdB;

wire MEM_regwrite, MEM_memtoreg,
     MEM_memread, MEM_memwrite;
wire [31:0] MEM_aluresult, MEM_instr,
            MEM_writedata, MEM_readdata;


wire WB_regwrite, WB_memtoreg;
wire [31:0] WB_aluresult, WB_readdata, WB_instr;
wire [31:0] WB_writedata;

MUX32 IF_mux(
    .zero(IF_adderout), .one(ID_adderout),
    .select_bit(ID_FlushIF),
    .out(IF_muxout)
);

PC PC(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .PCWrite_i(ID_PCwrite),
    .pc_i(IF_muxout),
    .pc_o(IF_PCout)
);

Instruction_Memory Instruction_Memory(
    .addr_i(IF_PCout),
    .instr_o(IF_instr)
);

Adder IF_adder(
    .valueA_i(IF_PCout), .valueB_i(32'b100),
    .value_o(IF_adderout)
);

IFID IFID(
    .rst_i(rst_i),
    .clk_i(clk_i),
    
    .pc_i(IF_PCout),
    .pc_o(ID_PCout),

    .Inst_i(IF_instr),
    .Inst_o(ID_instr),
    
    .flush(ID_FlushIF),
    .stall(ID_stallout)
);


LeftShifter ID_ls(
    .value_i(ID_imm),
    .value_o(ID_addertop)
);

Adder ID_adder(
    .valueA_i(ID_addertop), .valueB_i(ID_PCout),
    .value_o(ID_adderout)
);

AndUnit ID_and(
    .value_a(ID_branchout), .value_b(ID_equalout),
    .value_o(ID_FlushIF)
);

EqualUnit ID_equal(
    .value_a(ID_Data1), .value_b(ID_Data2),
    .value_o(ID_equalout)
);


Control Control(
    .Inst_i(ID_instr[6:0]),

    .NoOp(ID_noopout),
    .rst_i(rst_i),
    .clk_i(clk_i),

    .ALUOp_o(ID_aluop),
    .ALUSrc_o(ID_alusrc), .RegWrite_o(ID_regwrite),

    .Branch_o(ID_branchout),
    .MemtoReg(ID_memtoreg),
    .MemRead(ID_memread), .MemWrite(ID_memwrite)
);

Registers Registers(
    .rst_i(rst_i),
    .clk_i(clk_i),
    .RS1addr_i(ID_instr[19:15]),
    .RS2addr_i(ID_instr[24:20]),
    .RDaddr_i(WB_instr[11:7]), 
    .RDdata_i(WB_writedata),
    .RegWrite_i(WB_regwrite), 
    .RS1data_o(ID_Data1), 
    .RS2data_o(ID_Data2) 
);

ImmGen ID_ImmGen(
    .Inst_i(ID_instr),
    .ImmGen_o(ID_imm)
);

HarzardUnit Hazard_Detection(
    .ID_Rs1_i(ID_instr[19:15]),
    .ID_Rs2_i(ID_instr[24:20]),
    .EX_Rd_i(EX_instr[11:7]),
    .EX_MemRead_i(EX_memread),
    .NoOp_o(ID_noopout), .Stall_o(ID_stallout),
    .PC_Write_o(ID_PCwrite),
    .rst_i(rst_i), .clk_i(clk_i)
);

IDEX IDEX (
    .RegWrite_i(ID_regwrite),
    .MemtoReg_i(ID_memtoreg),
    .MemRead_i(ID_memread),
    .MemWrite_i(ID_memwrite),
    .ALUOp_i(ID_aluop),
    .ALUSrc_i(ID_alusrc),
    .ReadData1_i(ID_Data1),
    .ReadData2_i(ID_Data2),
    .ImmGen_i(ID_imm),
    .Inst_i(ID_instr),

    .RegWrite_o(EX_regwrite),
    .MemtoReg_o(EX_memtoreg),
    .MemRead_o(EX_memread),
    .MemWrite_o(EX_memwrite),
    .ALUOp_o(EX_aluop),
    .ALUSrc_o(EX_alusrc),
    .ReadData1_o(EX_Data1),
    .ReadData2_o(EX_Data2),
    .ImmGen_o(EX_imm),
    .Inst_o(EX_instr),

    .rst_i(rst_i),
    .clk_i(clk_i)
);

MUX32_4 EX_tmux(
    .zero_zero(EX_Data1), .zero_one(WB_writedata),
    .one_zero(MEM_aluresult), .one_one(),
    .select_bit(EX_fwdA),
    .out(EX_aluvalue1)
);


MUX32_4 EX_dmux(
    .zero_zero(EX_Data2), .zero_one(WB_writedata),
    .one_zero(MEM_aluresult), .one_one(),
    .select_bit(EX_fwdB),
    .out(EX_muxzero)
);

MUX32 EX_mux(
    .zero(EX_muxzero), .one(EX_imm),
    .select_bit(EX_alusrc),
    .out(EX_aluvalue2)
);

ALU_Control EX_ALUcon(
    .ALUop_i(EX_aluop),
    .func3(EX_instr[14:12]),
    .func7(EX_instr[31:25]),
    .ALUfunc_o(EX_alufunc)
);

ALU EX_ALU(
    .Data1(EX_aluvalue1), .Data2(EX_aluvalue2),
    .ALUfunc_i(EX_alufunc),
    .ALUresult_o(EX_aluresult)
);

FwdUnit EX_fwd(
    .MEM_RegWrite_i(MEM_regwrite),
    .MEM_Rd_i(MEM_instr[11:7]),

    .WB_RegWrite_i(WB_regwrite),
    .WB_Rd_i(WB_instr[11:7]),

    .EX_Rs1_i(EX_instr[19:15]),
    .EX_Rs2_i(EX_instr[24:20]),

    .FwdA_o(EX_fwdA),
    .FwdB_o(EX_fwdB)
);


EXMEM EXMEM(
    .RegWrite_i(EX_regwrite),
    .MemtoReg_i(EX_memtoreg),
    .MemRead_i(EX_memread),
    .MemWrite_i(EX_memwrite),

    .ALUresult_i(EX_aluresult),
    .ReadData2_i(EX_muxzero),
    .Inst_i(EX_instr),

    .RegWrite_o(MEM_regwrite),
    .MemtoReg_o(MEM_memtoreg),
    .MemRead_o(MEM_memread),
    .MemWrite_o(MEM_memwrite),

    .ALUresult_o(MEM_aluresult),
    .ReadData2_o(MEM_writedata),
    .Inst_o(MEM_instr),

    .rst_i(rst_i),
    .clk_i(clk_i)
);

Data_Memory Data_Memory(
    .clk_i(clk_i),
    .addr_i(MEM_aluresult),
    .MemRead_i(MEM_memread),
    .MemWrite_i(MEM_memwrite),
    .data_i(MEM_writedata),
    .data_o(MEM_readdata)
);

MEMWB MEMWB (
    .RegWrite_i(MEM_regwrite),
    .MemtoReg_i(MEM_memtoreg),

    .ALUresult_i(MEM_aluresult),
    .ReadData_i(MEM_readdata),
    .Inst_i(MEM_instr),

    .RegWrite_o(WB_regwrite),
    .MemtoReg_o(WB_memtoreg),

    .ALUresult_o(WB_aluresult),
    .ReadData_o(WB_readdata),
    .Inst_o(WB_instr),

    .rst_i(rst_i),
    .clk_i(clk_i)
);

MUX32 WB_mux (
    .zero(WB_aluresult), .one(WB_readdata),
    .select_bit(WB_memtoreg),
    .out(WB_writedata)
);

endmodule

