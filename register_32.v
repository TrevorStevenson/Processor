module register_32(clock, writeEnable, reset, d, q);

	input clock, writeEnable, reset;
	input [6:0] d;
	output [6:0] q;
	
	genvar i;
	generate
	for (i = 0; i < 7; i = i + 1)
	begin : flip
		dflipflop2 flippy(d[i], clock, ~reset, 1'b1, writeEnable, q[i]);
	end
	endgenerate


endmodule