module fAdder(a, b, cin, sum, cout);

	input a, b, cin;
	
	output sum, cout;
	
	wire w1, w2, w3;
	
	xor xor1(sum, a, b, cin);
	and and1(w1, a, b);
	and and2(w2, a, cin);
	and and3(w3, b, cin);
	or or1(cout, w1, w2, w3);
	
endmodule