`timescale 1 ns / 100 ps
module testbench();

	reg clock, reset;
		
	skeleton skelly(clock, reset);
		
	initial
	begin
		clock = 1'b0;
		reset = 1'b1;
		
		@(negedge clock);
		@(negedge clock);
		
		reset = 1'b0;
		@(negedge clock);
		
		$display("%b", skelly.my_processor.address_imem);
		
		@(posedge clock);
		$display("%b", skelly.my_processor.pc);
		
		@(posedge clock);
		$display("%b", skelly.my_processor.pc);
		
		@(posedge clock);
		$display("%b", skelly.my_processor.pc);
	end
	
	always
		#20 clock = ~clock;
		
endmodule

		
		