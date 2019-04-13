module div_control(in, bt, write);

	input [31:0] in;
	
	output bt, write;
	
	assign bt = ~in[31];
	assign write = in[31];

endmodule