module fetch_decode(clock, we, reset, pc, instruction, pc_out, instruction_out);

input clock, reset, we;

input [31:0] pc, instruction;

output [31:0] pc_out, instruction_out;

register pc_register(clock, we, reset, pc, pc_out);
register insn_register(clock, we, reset, instruction, instruction_out);

endmodule