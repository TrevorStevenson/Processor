module shiftRight4(in, out);

	input [31:0] in;
	
	output [31:0] out;
	
	assign out[27:0] = in[31:4];
	assign out[31:28] = {4{in[31]}};

endmodule