module mux32to1(select, in, out);

	input [4:0] select;
	input [1023:0] in;
	output [31:0] out;
	
	wire [31:0] decoOut;
	
	wire [31:0] w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31, w32;
	
	decoder deco(select, decoOut);
	
	assign w1 = in[31:0];
	assign w2 = in[63:32];
	assign w3 = in[95:64];
	assign w4 = in[127:96];
	assign w5 = in[159:128];
	assign w6 = in[191:160];
	assign w7 = in[223:192];
	assign w8 = in[255:224];
	assign w9 = in[287:256];
	assign w10 = in[319:288];
	assign w11 = in[351:320];
	assign w12 = in[383:352];
	assign w13 = in[415:384];
	assign w14 = in[447:416];
	assign w15 = in[479:448];
	assign w16 = in[511:480];
	assign w17 = in[543:512];
	assign w18 = in[575:544];
	assign w19 = in[607:576];
	assign w20 = in[639:608];
	assign w21 = in[671:640];
	assign w22 = in[703:672];
	assign w23 = in[735:704];
	assign w24 = in[767:736];
	assign w25 = in[799:768];
	assign w26 = in[831:800];
	assign w27 = in[863:832];
	assign w28 = in[895:864];
	assign w29 = in[927:896];
	assign w30 = in[959:928];
	assign w31 = in[991:960];
	assign w32 = in[1023:992];
	
	assign out = decoOut[0] ? w1 : 1'bz;
	assign out = decoOut[1] ? w2 : 1'bz;
	assign out = decoOut[2] ? w3 : 1'bz;
	assign out = decoOut[3] ? w4 : 1'bz;
	assign out = decoOut[4] ? w5 : 1'bz;
	assign out = decoOut[5] ? w6 : 1'bz;
	assign out = decoOut[6] ? w7 : 1'bz;
	assign out = decoOut[7] ? w8 : 1'bz;
	assign out = decoOut[8] ? w9 : 1'bz;
	assign out = decoOut[9] ? w10 : 1'bz;
	assign out = decoOut[10] ? w11 : 1'bz;
	assign out = decoOut[11] ? w12 : 1'bz;
	assign out = decoOut[12] ? w13 : 1'bz;
	assign out = decoOut[13] ? w14 : 1'bz;
	assign out = decoOut[14] ? w15 : 1'bz;
	assign out = decoOut[15] ? w16 : 1'bz;
	assign out = decoOut[16] ? w17 : 1'bz;
	assign out = decoOut[17] ? w18 : 1'bz;
	assign out = decoOut[18] ? w19 : 1'bz;
	assign out = decoOut[19] ? w20 : 1'bz;
	assign out = decoOut[20] ? w21 : 1'bz;
	assign out = decoOut[21] ? w22 : 1'bz;
	assign out = decoOut[22] ? w23 : 1'bz;
	assign out = decoOut[23] ? w24 : 1'bz;
	assign out = decoOut[24] ? w25 : 1'bz;
	assign out = decoOut[25] ? w26 : 1'bz;
	assign out = decoOut[26] ? w27 : 1'bz;
	assign out = decoOut[27] ? w28 : 1'bz;
	assign out = decoOut[28] ? w29 : 1'bz;
	assign out = decoOut[29] ? w30 : 1'bz;
	assign out = decoOut[30] ? w31 : 1'bz;
	assign out = decoOut[31] ? w32 : 1'bz;
	
endmodule