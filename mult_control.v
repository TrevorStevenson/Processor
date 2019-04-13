module mult_control(in, sign, zero);

	input [1:0] in;
	output sign, zero;	
	
	and and1(sign, in[1], ~in[0]);
	
	xnor xnor1(zero, in[1], in[0]);
	
endmodule