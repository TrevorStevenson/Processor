module dflipflop(clock, writeEnable, reset, d, q);

	input clock, writeEnable, reset, d;
	output reg q;
	
	always @(posedge clock) 
	begin
		if (reset) q <= 1'b0;
		else if (writeEnable) q <= d;
	end
	
endmodule