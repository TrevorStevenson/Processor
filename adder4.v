module adder4(a, b, cin, sum, cout, ovf);

	input [7:0] a, b;
	input cin;
	
	output [7:0] sum;
	output cout, ovf;
	
	wire c1, c2, c3, c4, c5, c6, c7;
	
	fAdder f1(a[0], b[0], cin, sum[0], c1);
	fAdder f2(a[1], b[1], c1, sum[1], c2);
	fAdder f3(a[2], b[2], c2, sum[2], c3);
	fAdder f4(a[3], b[3], c3, sum[3], c4);
	fAdder f5(a[4], b[4], c4, sum[4], c5);
	fAdder f6(a[5], b[5], c5, sum[5], c6);
	fAdder f7(a[6], b[6], c6, sum[6], c7);
	fAdder f8(a[7], b[7], c7, sum[7], cout);
	
	xor ovrflw(ovf, cout, c7);

endmodule