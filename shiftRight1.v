module shiftRight1(in, out);

	input [31:0] in;
	
	output [31:0] out;
	
	assign out[30:0] = in[31:1];
	assign out[31] = in[31];

endmodule