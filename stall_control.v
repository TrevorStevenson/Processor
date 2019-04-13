module stall_control(execute_insn, decode_insn, stall);

	input [31:0] execute_insn, decode_insn;
	
	output stall;
	
	wire [4:0] execute_op, decode_rt, execute_rd, decode_rs, decode_op;
	
	assign execute_op = execute_insn[31:27];
	assign decode_rt = decode_insn[16:12];
	assign execute_rd = execute_insn[26:22];
	assign decode_rs = decode_insn[21:17];
	assign decode_op = decode_insn[31:27];
	
	wire lw;
	assign lw = execute_op[3];
	
	wire [4:0] rd_eq;
	wire w1;

	genvar i;
	generate
	for (i = 0; i < 5; i = i + 1) 
	begin : rd_equaltiy
		xor(rd_eq[i], decode_rt[i], execute_rd[i]);
	end
	endgenerate

	wire rd_not_eq;
	or not_eq(rd_not_eq, rd_eq[0], rd_eq[1], rd_eq[2], rd_eq[3], rd_eq[4]);

	assign w1 = ~rd_not_eq;
	
	wire [4:0] rd_eq2;
	wire w2;

	genvar i2;
	generate
	for (i2 = 0; i2 < 5; i2 = i2 + 1) 
	begin : rd_equaltiy2
		xor(rd_eq2[i2], decode_rs[i2], execute_rd[i2]);
	end
	endgenerate

	wire rd_not_eq2;
	or not_eq2(rd_not_eq2, rd_eq2[0], rd_eq2[1], rd_eq2[2], rd_eq2[3], rd_eq2[4]);

	assign w2 = ~rd_not_eq2;
	
	wire sw;
	assign sw = decode_op[2] & decode_op[1] & decode_op[0];
	
	assign stall = lw & (w1 | (w2 & sw));
	
endmodule