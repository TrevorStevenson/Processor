module counter(clock, reset, stp, load, countOut);

	input clock, reset;
	
	output stp, load;
	output [6:0] countOut;
	
	wire [6:0] regOut;
	wire [6:0] addOut;
	wire cout, ovf;
	
	csa32 c1(7'b000001, regOut, 1'b0, addOut, cout, ovf);
	register_32 rgstr(clock, 1'b1, reset, addOut, regOut);
	
	//and and1(stp, ~regOut[5], ~regOut[4], ~regOut[3], ~regOut[2], ~regOut[1], ~regOut[0], ~reset, clock);
	assign stp = regOut[6];
	assign load = ~regOut[0];
	
	assign countOut = regOut;
	
endmodule