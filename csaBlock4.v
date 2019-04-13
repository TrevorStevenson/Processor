module csaBlock4(a, b, cin, sum, cout, ovf);

	input [7:0] a, b;
	input cin;
	
	output [7:0] sum;
	output cout, ovf;
	
	wire [7:0] sum0, sum1;
	wire c0, c1;
	wire o0, o1;
	
	adder4 a41(a, b, 1'b0, sum0, c0, o0);
	adder4 a42(a, b, 1'b1, sum1, c1, o1);
	
	assign sum = cin ? sum1 : sum0;
	assign cout = cin ? c1 : c0;
	assign ovf = cin ? o1 : o0;

endmodule