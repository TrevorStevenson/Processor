module dflipflopNeg(d, clk, clrn, prn, ena, q);

    input d, clk, ena, clrn, prn;
    wire clr;
    wire pr;

    output q;
    reg q;

    assign clr = ~clrn;
    assign pr = ~prn;

    initial
    begin
        q = 1'b0;
    end

    always @(negedge clk) begin
        if (q == 1'bx) begin
            q <= 1'b0;
        end else if (clr) begin
            q <= 1'b0;
        end else if (ena) begin
            q <= d;
        end
		 
    end
endmodule
