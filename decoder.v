module decoder(select, out);

	input [4:0] select;
	output [31:0] out;
	
	wire w1, w2, w3, w4, w5;
	
	not not1(w1, select[0]);
	not not2(w2, select[1]);
	not not3(w3, select[2]);
	not not4(w4, select[3]);
	not not5(w5, select[4]);
	
	and and1(out[0], w1, w2, w3, w4, w5);
	
	and and2(out[1], select[0], w2, w3, w4, w5);
	
	and and3(out[2], w1, select[1], w3, w4, w5);
	and and4(out[3], select[0], select[1], w3, w4, w5);
	
	and and5(out[4], w1, w2, select[2], w4, w5);
	and and6(out[5], select[0], w2, select[2], w4, w5);
	and and7(out[6], w1, select[1], select[2], w4, w5);
	and and8(out[7], select[0], select[1], select[2], w4, w5);
	
	and and9(out[8], w1, w2, w3, select[3], w5);
	and and10(out[9], select[0], w2, w3, select[3], w5);
	and and11(out[10], w1, select[1], w3, select[3], w5);
	and and12(out[11], select[0], select[1], w3, select[3], w5);
	and and13(out[12], w1, w2, select[2], select[3], w5);
	and and14(out[13], select[0], w2, select[2], select[3], w5);
	and and15(out[14], w1, select[1], select[2], select[3], w5);
	and and16(out[15], select[0], select[1], select[2], select[3], w5);
	
	and and17(out[16], w1, w2, w3, w4, select[4]);
	and and18(out[17], select[0], w2, w3, w4, select[4]);
	and and19(out[18], w1, select[1], w3, w4, select[4]);
	and and20(out[19], select[0], select[1], w3, w4, select[4]);
	and and21(out[20], w1, w2, select[2], w4, select[4]);
	and and22(out[21], select[0], w2, select[2], w4, select[4]);
	and and23(out[22], w1, select[1], select[2], w4, select[4]);
	and and24(out[23], select[0], select[1], select[2], w4, select[4]);
	and and25(out[24], w1, w2, w3, select[3], select[4]);
	and and26(out[25], select[0], w2, w3, select[3], select[4]);
	and and27(out[26], w1, select[1], w3, select[3], select[4]);
	and and28(out[27], select[0], select[1], w3, select[3], select[4]);
	and and29(out[28], w1, w2, select[2], select[3], select[4]);
	and and30(out[29], select[0], w2, select[2], select[3], select[4]);
	and and31(out[30], w1, select[1], select[2], select[3], select[4]);
	and and32(out[31], select[0], select[1], select[2], select[3], select[4]);
	
endmodule
	
	
	
	