module shiftRight16(in, out);

	input [31:0] in;
	
	output [31:0] out;
	
	assign out[15:0] = in[31:16];
	assign out[31:16] = {16{in[31]}};

endmodule