module decode_execute(clock, reset, dataA, dataB, instruction, pc, dataA_out, dataB_out, instruction_out, pc_out);

input clock, reset;

input [31:0] dataA, dataB, instruction, pc;

output [31:0] dataA_out, dataB_out, instruction_out, pc_out;

register dataAreg(clock, 1'b1, reset, dataA, dataA_out);
register dataBreg(clock, 1'b1, reset, dataB, dataB_out);

register insn_register(clock, 1'b1, reset, instruction, instruction_out);

register pc_reg(clock, 1'b1, reset, pc, pc_out);

endmodule