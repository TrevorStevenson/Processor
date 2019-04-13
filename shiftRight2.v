module shiftRight2(in, out);

	input [31:0] in;
	
	output [31:0] out;
	
	assign out[29:0] = in[31:2];
	assign out[31:30] = {2{in[31]}};

endmodule