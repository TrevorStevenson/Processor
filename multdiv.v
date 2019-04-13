module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, 
					data_result, data_exception, data_resultRDY);
					
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
	 
	 wire reset;
	 or rst(reset, ctrl_MULT, ctrl_DIV);
	 
	 // Latch the reset
	 wire init;
	 dflipflop2 rstLatch(reset, clock, 1'b1, 1'b1, 1'b1, init);
	 
	 wire load, stop;
	 counter ct(clock, reset, stop, load, countOut);
	 
	 wire [31:0] multiplier_init, regLower;
	 wire [63:0] regOut, regIn;
	 assign regLower = regOut[31:0];
	 assign multiplier_init = init ? data_operandB : regLower;
	 assign regIn = load ? loadInput : regShift;

	 rgstr_64 r64(clock, 1'b1, reset, regIn, regOut);
	 
	 wire [63:0] regShift;
	 shiftRight1 sr(regOut, regShift);
	 
	 wire p0;
	 dflipflop2 lastBit(regOut[0], clock, ~reset, 1'b1, 1'b1, p0);
	 
	 wire control_init;
	 assign control_init = init ? data_operandB[0] : regOut[0];
	 
	 wire sub, zero;
	 mult_control mc({control_init, p0}, sub, zero);
	 
	 wire [31:0] sub_mult;
	 assign sub_mult = sub ? ~data_operandA : data_operandA;
	 
	 wire [31:0] adderIn1, adderIn2;
	 assign adderIn1 = regOut[63:32];
	 assign adderIn2 = zero ? 32'b0 : sub_mult;
	 
	 wire cout, addOvf;
	 wire [31:0] adderOut;
	 csa32 adder(adderIn1, adderIn2, sub, adderOut, cout, addOvf);
	 
	 wire [63:0] loadInput;
	 assign loadInput = {adderOut, multiplier_init};
	 
	 // Latch the subtract
	 
	 wire isSub;
	 wire [64:0] subL;
	 dflipflopNeg f0(ctrl_DIV, reset, 1'b1, 1'b1, 1'b1, subL[0]);
	 assign isSub = subL[0];

	 // Divison Circuit	
	 
	 wire [31:0] dividend_init, regLowerSub, regLowerLSB, regUpperSub, subAnswer;
	 wire [31:0] opASub, opBSub, negA, negB;
	 wire negateAnswer, o1, c1, o2, c2;
	 wire [63:0] regOutSub, regInSub;
	 
	 csa32 flipOpA(~data_operandA, 32'b1, 1'b0, negA, c1, o1);
	 csa32 flipOpB(~data_operandB, 32'b1, 1'b0, negB, c2, o2);
	 
	 assign opASub = data_operandA[31] ? negA : data_operandA;
	 assign opBSub = data_operandB[31] ? negB : data_operandB;
	 assign negateAnswer = subL[0] & (data_operandA[31] & ~data_operandB[31]) | (~data_operandA[31] & data_operandB[31]);
	 assign regLowerSub = regOutSub[31:0];
	 assign regLowerLSB = {regLowerSub[31:1], lsb};
	 assign regUpperSub = regOutSub[63:32];
	 assign dividend_init = init ? opASub : regLowerLSB;
	 assign regInSub = load ? loadInputSub : regShiftSub;
	 assign subAnswer = regOutSub[31:0];

	 rgstr_64 r64Sub(clock, 1'b1, reset, regInSub, regOutSub);
	 
	 wire [63:0] regShiftSub;
	 shiftLeft1 sl(regOutSub, regShiftSub);
	 
	 wire lsb, writeSub;
	 div_control dc(adderOutSub, lsb, writeSub);
	 
	 wire [31:0] adderIn1Sub, adderIn2Sub;
	 assign adderIn1Sub = regOutSub[63:32];
	 assign adderIn2Sub = ~opBSub;
	 
	 wire coutSub, oSub;
	 wire [31:0] adderOutSub, adderOutput;
	 csa32 adderSub(adderIn1Sub, adderIn2Sub, 1'b1, adderOutSub, coutSub, oSub);
	 assign adderOutput = writeSub ? regUpperSub : adderOutSub;
	 
	 wire [63:0] loadInputSub;
	 assign loadInputSub = {adderOutput, dividend_init};
	 
	 // Final data result
	 
	 wire [31:0] and1, and2, and3, andTotal, negAnd1;
	 wire caf, cof;
	 assign and1 = {32{subL[0]}} & regLowerSub;
	 assign and2 = {32{~subL[0]}} & regLower;
	 
	 csa32 flipAnd1(~and1, 32'b1, 1'b0, negAnd1, caf, cof);
	 
	 assign and3 = (negateAnswer & subL[0]) ? negAnd1 : and1;
	 
	 assign andTotal = and3 | and2;
	 
	 assign data_result = andTotal;
	 
	 // Data result ready
	 
	 wire rdy;
	 dflipflop2 rdyLatch(stop, clock, ~reset, 1'b1, 1'b1, rdy);
	 
	 assign data_resultRDY = (stop & ~subL[0]) | (rdy & subL[0]);
	 
	 // Overflow calculation
	 
	 wire allSame, allZeros, multOvf1, multOvf2, multOvf3, multOvf4, multOvf;
	 assign multOvf1 = regOut[63] & regOut[62] & regOut[61] & regOut[60] & regOut[59] &
							regOut[58] & regOut[57] & regOut[56] & regOut[55] & regOut[54] &
							regOut[53] & regOut[52] & regOut[51] & regOut[50] & regOut[49] &
							regOut[48] & regOut[47] & regOut[46] & regOut[45] & regOut[44] &
							regOut[43] & regOut[42] & regOut[41] & regOut[40] & regOut[39] &
							regOut[38] & regOut[37] & regOut[36] & regOut[35] & regOut[34] &
							regOut[33] & regOut[32];
							
	wire [63:0] notRegOut;
	assign notRegOut = ~regOut;
							
	assign multOvf2 = notRegOut[63] & notRegOut[62] & notRegOut[61] & notRegOut[60] & notRegOut[59] &
							notRegOut[58] & notRegOut[57] & notRegOut[56] & notRegOut[55] & notRegOut[54] &
							notRegOut[53] & notRegOut[52] & notRegOut[51] & notRegOut[50] & notRegOut[49] &
							notRegOut[48] & notRegOut[47] & notRegOut[46] & notRegOut[45] & notRegOut[44] &
							notRegOut[43] & notRegOut[42] & notRegOut[41] & notRegOut[40] & notRegOut[39] &
							notRegOut[38] & notRegOut[37] & notRegOut[36] & notRegOut[35] & notRegOut[34] &
							notRegOut[33] & notRegOut[32];
							
	assign allZeros = notRegOut[63] & notRegOut[62] & notRegOut[61] & notRegOut[60] & notRegOut[59] &
							notRegOut[58] & notRegOut[57] & notRegOut[56] & notRegOut[55] & notRegOut[54] &
							notRegOut[53] & notRegOut[52] & notRegOut[51] & notRegOut[50] & notRegOut[49] &
							notRegOut[48] & notRegOut[47] & notRegOut[46] & notRegOut[45] & notRegOut[44] &
							notRegOut[43] & notRegOut[42] & notRegOut[41] & notRegOut[40] & notRegOut[39] &
							notRegOut[38] & notRegOut[37] & notRegOut[36] & notRegOut[35] & notRegOut[34] &
							notRegOut[33] & notRegOut[32] & notRegOut[31] & notRegOut[30] & notRegOut[29] &
							notRegOut[28] & notRegOut[27] & notRegOut[26] & notRegOut[25] & notRegOut[24] &
							notRegOut[23] & notRegOut[22] & notRegOut[21] & notRegOut[20] & notRegOut[19] &
							notRegOut[18] & notRegOut[17] & notRegOut[16] & notRegOut[15] & notRegOut[14] &
							notRegOut[13] & notRegOut[12] & notRegOut[11] & notRegOut[10] & notRegOut[9] &
							notRegOut[8] & notRegOut[7] & notRegOut[6] & notRegOut[6] & notRegOut[4] & 
							notRegOut[3] & notRegOut[2] & notRegOut[1] & notRegOut[0];
	
	assign allSame = multOvf1 | multOvf2;
	assign multOvf3 = allSame & ((data_operandA[31] & ~data_operandB[31]) | (~data_operandA[31] & data_operandB[31])) & regOut[31];
	assign multOvf4 =	allSame & ((data_operandA[31] & data_operandB[31]) | (~data_operandA[31] & ~data_operandB[31])) & notRegOut[31];
	
	or ovfOr(multOvf, multOvf3, multOvf4, allZeros);
	
	// Division exception
	 
	wire divBy0;
	assign divBy0 = 	~data_operandB[31] & ~data_operandB[30] & ~data_operandB[29] & ~data_operandB[28] & ~data_operandB[27] &
							~data_operandB[26] & ~data_operandB[25] & ~data_operandB[24] & ~data_operandB[23] & ~data_operandB[22] &
							~data_operandB[21] & ~data_operandB[20] & ~data_operandB[19] & ~data_operandB[18] & ~data_operandB[17] &
							~data_operandB[16] & ~data_operandB[15] & ~data_operandB[14] & ~data_operandB[13] & ~data_operandB[12] &
							~data_operandB[11] & ~data_operandB[10] & ~data_operandB[9] & ~data_operandB[8] & ~data_operandB[7] &
							~data_operandB[6] & ~data_operandB[5] & ~data_operandB[4] & ~data_operandB[3] & ~data_operandB[2] &
							~data_operandB[1] & ~data_operandB[0];
	
	assign data_exception = (~multOvf & ~subL[0]) | (divBy0 & subL[0]);
	 
	//assign dataOut = regOut;
	//assign inter = multOvf4;
	//assign subSig = subL;
	//assign subOut = regOutSub;
	//assign ans = and1 | and2;
	
endmodule
