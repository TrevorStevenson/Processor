module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

	// Bitwise AND
	
	wire [31:0] andWire;
	
	genvar i;
	generate
		for (i = 0; i < 32; i = i+1)
		begin : bitAND
			and andGate(andWire[i], data_operandA[i], data_operandB[i]);
		end
	endgenerate
	
	// Bitwise OR
	
	wire [31:0] orWire;
	
	generate
		for (i = 0; i < 32; i = i+1)
		begin : bitOR
			or orGate(orWire[i], data_operandA[i], data_operandB[i]);
		end
	endgenerate
	
	// Adder
	
	wire C0, C1;
	wire w1, w2;
	wire O1;
	
	wire [31:0] addWire;
	
	not not1(w1, ctrl_ALUopcode[2]);
	not not2(w2, ctrl_ALUopcode[1]);
	and subCarry(C0, w1, w2, ctrl_ALUopcode[0]);
	
	wire [31:0] opB;
	
	generate
	for (i = 0; i < 32; i = i + 1)
	begin : subtract
		wire w;
		not notGate(w, data_operandB[i]);
		assign opB[i] = C0 ? w : data_operandB[i];
	end
	endgenerate
	
	csa32 csacsa(data_operandA, opB, C0, addWire, C1, O1);
	
	// Barrel Shifter
	
	// sll
	
	wire [31:0] s1, s2, s3, s4, s5, s6, s7, s8, s9;
	wire [31:0] shiftLWire;
	
	shiftLeft16 sl16(data_operandA, s1);
	
	assign s2 = ctrl_shiftamt[4] ? s1 : data_operandA;
	
	shiftLeft8 sl8(s2, s3);
	
	assign s4 = ctrl_shiftamt[3] ? s3 : s2;
	
	shiftLeft4 sl4(s4, s5);
	
	assign s6 = ctrl_shiftamt[2] ? s5 : s4;
	
	shiftLeft2 sl2(s6, s7);
	
	assign s8 = ctrl_shiftamt[1] ? s7 : s6;
	
	shiftLeft1 sl1(s8, s9);
	
	assign shiftLWire = ctrl_shiftamt[0] ? s9 : s8;
	
	// sra
	
	wire [31:0] r1, r2, r3, r4, r5, r6, r7, r8, r9;
	wire [31:0] shiftRWire;
	
	shiftRight16 sr16(data_operandA, r1);
	
	assign r2 = ctrl_shiftamt[4] ? r1 : data_operandA;
	
	shiftRight8 sr8(r2, r3);
	
	assign r4 = ctrl_shiftamt[3] ? r3 : r2;
	
	shiftRight4 sr4(r4, r5);
	
	assign r6 = ctrl_shiftamt[2] ? r5 : r4;
	
	shiftRight2 sr2(r6, r7);
	
	assign r8 = ctrl_shiftamt[1] ? r7 : r6;
	
	shiftRight1 sr1(r8, r9);
	
	assign shiftRWire = ctrl_shiftamt[0] ? r9 : r8;	
	
	// Mux
	
	wire m1, m2, m3, m4, m5, m6, m7, m8;
	
	not notm1(m1, ctrl_ALUopcode[2]);
	not notm2(m2, ctrl_ALUopcode[1]);
	not notm3(m3, ctrl_ALUopcode[0]);
	
	// add or sub opcode
	
	and addSub(m4, m1, m2);
	
	// bitwise AND opcode
	
	and andOP(m5, ctrl_ALUopcode[1], m3);
	
	// bitwise OR opcode
	
	and orOP(m6, ctrl_ALUopcode[1], ctrl_ALUopcode[0]);
	
	// sll opcode
	
	and sll(m7, ctrl_ALUopcode[2], m3);
	
	//sra opcode
	
	and sra(m8, ctrl_ALUopcode[2], ctrl_ALUopcode[0]);
	
	assign data_result = m5 ? andWire : 32'bz;
	assign data_result = m6 ? orWire : 32'bz;
	assign data_result = m4 ? addWire : 32'bz;
	assign data_result = m7 ? shiftLWire : 32'bz;
	assign data_result = m8 ? shiftRWire : 32'bz;
	
	// isNotEqual
	
	wire [31:0] t;
	wire t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
	
	generate
	for (i = 0; i < 32; i = i + 1)
	begin : notEq
		xor xorGate(t[i], data_operandA[i], data_operandB[i]);
	end
	endgenerate
	
	or nor1(t1, t[0], t[1], t[2], t[3]);
	or nor2(t2, t[8], t[9], t[10], t[11]);
	or nor3(t3, t[16], t[17], t[18], t[19]);
	or nor4(t4, t[24], t[25], t[26], t[27]);
	or por1(t5, t[4], t[5], t[6], t[7]);
	or por2(t6, t[12], t[13], t[14], t[15]);
	or por3(t7, t[20], t[21], t[22], t[23]);
	or por4(t8, t[28], t[29], t[30], t[31]);
	or nor6(t9, t1, t2, t3, t4);
	or nor7(t10, t5, t6, t7, t8);
	or nor5(isNotEqual, t9, t10);
	
	// isLessThan
	
	wire l1;
	
	and lt1(l1, O1, data_operandA[31]);
	assign isLessThan = O1 ? l1 : data_result[31];
	
	// overflow
	
	assign overflow = O1;

endmodule
