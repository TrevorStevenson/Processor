module rgstr_64(clock, writeEnable, reset, d, q);

	input clock, writeEnable, reset;
	input [63:0] d;
	output [63:0] q;
	
	genvar i;
	generate
	for (i = 0; i < 64; i = i + 1)
	begin : flip
		dflipflop2 flippy(d[i], clock, ~reset, 1'b1, writeEnable, q[i]);
	end
	endgenerate


endmodule