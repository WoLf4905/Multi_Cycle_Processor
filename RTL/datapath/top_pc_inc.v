module top_pc_inc(
    input clk,
    input reset,
    input [5:0] opcode,
    input [5:0] funct
);

wire pcwrite;//becarefull
wire branch;//not connected
wire pcsrc;
wire [1:0] aluop;
wire alusrcA;
wire [1:0] alusrcB;
wire regwrite;
wire IorD;//not connected
wire memorywrite;
wire IRwrite;
wire regdst;
wire memtoreg;

wire [2:0] alucontrol;

wire [31:0] nextpc;
wire [31:0] pc;

wire [31:0] aluresult;
wire [31:0] aluout;

wire [31:0] RD2;
wire [31:0] signlmm;
wire [31:0] signlmm_2shift;
wire [31:0] srcB;

wire [31:0] RD1;
wire [31:0] srcA;

wire zero;

fsm fsm_1(
    .clk(clk),
    .reset(reset),
    .opcode(opcode),
    .funct(funct),

    .pcwrite(pcwrite),
    .branch(branch),
    .pcsrc(pcsrc),
    .aluop(aluop),
    .alusrcA(alusrcA),
    .alusrcB(alusrcB),
    .regwrite(regwrite),
    .IorD(IorD),
    .memorywrite(memorywrite),
    .IRwrite(IRwrite),
    .regdst(regdst),
    .memtoreg(memtoreg)
);

alu_decoder aludecoder(
    .aluop(aluop),
    .funct(funct),
    .alucontrol(alucontrol)
);

pc pc_1(
    .clk(clk),
    .reset(reset),
    .pcen(pcwrite),
    .nextpc(nextpc),
    .pc(pc)
);

pcsrc_mux mux_1(
    .aluresult(aluresult),
    .aluout(aluout),
    .pcsrc(pcsrc),
    .nextpc(nextpc)
);

alusrcB_mux mux_2(
    .alusrcB(alusrcB),
    .RD2(RD2),
    .signlmm(signlmm),
    .signlmm_2shift(signlmm_2shift),
    .srcB(srcB)
);

alusrcA_mux mux_3(
    .alusrcA(alusrcA),
    .pc(pc),
    .RD1(RD1),
    .srcA(srcA)
);

aluout aluout_1(
    .clk(clk),
    .reset(reset),
    .aluresult(aluresult),
    .aluout(aluout)
);

alu alu_1(
    .srcA(srcA),
    .srcB(srcB),
    .alucontrol(alucontrol),
    .zero(zero),
    .aluresult(aluresult)
);
endmodule