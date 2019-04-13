module csa32(a, b, cin, sum, cout, ovf);

	input [31:0] a, b;
	input cin;
	
	output [31:0] sum;
	output cout, ovf;
	
	wire c0, c1, c2, c3, c4, c5, c6, c7;
	wire o0, o1, o2, o3, o4, o5, o6, o7;

	adder4 a1(a[7:0], b[7:0], cin, sum[7:0], c0, o1);
	csaBlock4 a2(a[15:8], b[15:8], c0, sum[15:8], c1, o2);
	csaBlock4 a3(a[23:16], b[23:16], c1, sum[23:16], c2, o3);
	csaBlock4 a4(a[31:24], b[31:24], c2, sum[31:24], cout, ovf);

endmodule