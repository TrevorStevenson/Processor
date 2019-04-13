module shiftLeft1(in, out);

	input [31:0] in;
	
	output [31:0] out;
	
	assign out[31:1] = in[30:0];
	assign out[0] = 1'b0;

endmodule