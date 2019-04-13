module insn_signals(insn, rd, rs, rt, shamt, alu_op, immediate, target);

input [31:0] insn;

output [4:0] rd, rs, rt, shamt, alu_op;
output [16:0] immediate;
output [26:0] target;

assign rd = insn[26:22];
assign rs = insn[21:17];
assign rt = insn[16:12];

assign shamt = insn[11:7];
assign alu_op = insn[6:2];

assign immediate = insn[16:0];
assign target = insn[26:0];

endmodule