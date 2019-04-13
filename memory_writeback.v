module memory_writeback(clock, reset, alu_out, dmem_out, instruction, alu_output, dmem_output, instruction_output);

input clock, reset;

input [31:0] alu_out, dmem_out, instruction;

output [31:0] alu_output, dmem_output, instruction_output;

register alu_out_reg(clock, 1'b1, reset, alu_out, alu_output);
register dmem_out_reg(clock, 1'b1, reset, dmem_out, dmem_output);

register insn_register(clock, 1'b1, reset, instruction, instruction_output);

endmodule