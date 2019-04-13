module shiftLeft4(in, out);

	input [31:0] in;
	
	output [31:0] out;
	
	assign out[31:4] = in[27:0];
	assign out[3:0] = 4'b0;

endmodule