module register(clock, writeEnable, reset, d, q);

	input clock, writeEnable, reset;
	input [31:0] d;
	output [31:0] q;
	
	genvar i;
	generate
	for (i = 0; i < 32; i = i + 1) 
	begin : genDFFE
		dflipflop dflip(clock, writeEnable, reset, d[i], q[i]);
	end
	endgenerate

endmodule