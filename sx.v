module sx(immediate, sign_extended);

input [16:0] immediate;

output [31:0] sign_extended;

assign sign_extended[16:0] = immediate[16:0];
assign sign_extended[31:17] = {15{immediate[16]}};

endmodule