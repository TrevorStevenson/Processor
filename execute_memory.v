module execute_memory(clock, reset, alu_out, alu_in_B, instruction, dmem, alu_output, alu_in_B_output, instruction_output, dmem_wr);

input clock, reset, dmem;

input [31:0] alu_out, alu_in_B, instruction;

output [31:0] alu_output, alu_in_B_output, instruction_output;
output dmem_wr;

register alu_out_reg(clock, 1'b1, reset, alu_out, alu_output);
register alu_in_reg(clock, 1'b1, reset, alu_in_B, alu_in_B_output);
dflipflop dflip(clock, 1'b1, reset, dmem, dmem_wr);

register insn_register(clock, 1'b1, reset, instruction, instruction_output);

endmodule