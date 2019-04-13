module shiftRight8(in, out);

	input [31:0] in;
	
	output [31:0] out;
	
	assign out[23:0] = in[31:8];
	assign out[31:24] = {8{in[31]}};

endmodule