module bypass_control(writeback_insn, memory_insn, execute_insn, writeback_we, mem_we, mxB, wxB, mx, wx, dmemD);

input [31:0] writeback_insn, memory_insn, execute_insn;
input writeback_we, mem_we;

output mxB, wxB, mx, wx, dmemD;

wire [4:0] writeback_op, memory_op, execute_op;

assign writeback_op = writeback_insn[31:27];
assign memory_op = memory_insn[31:27];
assign execute_op = execute_insn[31:27];

wire [4:0] writeback_rd, memory_rd, execute_rs, execute_rt;

assign writeback_rd = writeback_insn[26:22];
assign memory_rd = memory_insn[26:22];
assign execute_rs = execute_insn[21:17];
assign execute_rt = execute_insn[16:12];

// mxB

wire [4:0] rt_rd_eq;

genvar t;
generate
for (t = 0; t < 5; t = t + 1) 
begin : rt_rd_equaltiy
	xor(rt_rd_eq[t], execute_rt[t], memory_rd[t]);
end
endgenerate

wire rt_rd_not_eq;
or rtdnot_eq(rt_rd_not_eq, rt_rd_eq[0], rt_rd_eq[1], rt_rd_eq[2], rt_rd_eq[3], rt_rd_eq[4]);

and mxband(mxB, ~rt_rd_not_eq, ~execute_op[4], ~execute_op[3], ~execute_op[2], ~execute_op[1], ~execute_op[0]);

// wxB

wire [4:0] rt_rd_eq2;

genvar p;
generate
for (p = 0; p < 5; p = p + 1) 
begin : rt_rd_equaltiy2
	xor(rt_rd_eq2[p], execute_rt[p], writeback_rd[p]);
end
endgenerate

wire rt_rd_not_eq2;
or rtdnot_eq2(rt_rd_not_eq2, rt_rd_eq2[0], rt_rd_eq2[1], rt_rd_eq2[2], rt_rd_eq2[3], rt_rd_eq2[4]);

and wxband(wxB, ~rt_rd_not_eq2, writeback_we);

// mx

wire [4:0] rs_rd_eq;

genvar j;
generate
for (j = 0; j < 5; j = j + 1) 
begin : rs_rd_equaltiy
	xor(rs_rd_eq[j], execute_rs[j], memory_rd[j]);
end
endgenerate

wire rs_rd_not_eq;
or rsdnot_eq(rs_rd_not_eq, rs_rd_eq[0], rs_rd_eq[1], rs_rd_eq[2], rs_rd_eq[3], rs_rd_eq[4]);

assign mx = ~rs_rd_not_eq;

// wx

wire [4:0] rs_rd_eq2;

genvar k;
generate
for (k = 0; k < 5; k = k + 1) 
begin : rs_rd_equaltiy2
	xor(rs_rd_eq2[k], execute_rs[k], writeback_rd[k]);
end
endgenerate

wire rs_rd_not_eq2;
or rsdnot_eq2(rs_rd_not_eq2, rs_rd_eq2[0], rs_rd_eq2[1], rs_rd_eq2[2], rs_rd_eq2[3], rs_rd_eq2[4]);

and wxand(wx, ~rs_rd_not_eq2, writeback_we);

// dmemD

wire writeback_sw, memory_lw;

and wsw(writeback_sw, writeback_op[2], writeback_op[1], writeback_op[0]);

assign memory_lw = memory_op[3];

wire [4:0] rd_eq;

genvar i;
generate
for (i = 0; i < 5; i = i + 1) 
begin : rd_equaltiy
	xor(rd_eq[i], writeback_rd[i], memory_rd[i]);
end
endgenerate

wire rd_not_eq;
or not_eq(rd_not_eq, rd_eq[0], rd_eq[1], rd_eq[2], rd_eq[3], rd_eq[4]);

assign dmemD = ~rd_not_eq;

endmodule