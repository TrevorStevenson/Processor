module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB,
	 regOne
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	
	output [31:0] regOne;

	wire [31:0] decoOut;
	wire weWires [31:0];
	wire [1023:0] regWires;
	
	// write enable
	
	// decoder
	decoder deco(ctrl_writeReg, decoOut);
	
	// and gates
	genvar i;
	generate
	for (i = 1; i < 32; i = i + 1) 
	begin : genAnd
		and(weWires[i], decoOut[i], ctrl_writeEnable);
	end
	endgenerate
	
	// registers
	
	// register 0 with constant 0 output.
	assign regWires[31:0] = 32'b0;
	
	register reg1(clock, weWires[1], ctrl_reset, data_writeReg, regWires[63:32]);
	register reg2(clock, weWires[2], ctrl_reset, data_writeReg, regWires[95:64]);
	register reg3(clock, weWires[3], ctrl_reset, data_writeReg, regWires[127:96]);
	register reg4(clock, weWires[4], ctrl_reset, data_writeReg, regWires[159:128]);
	register reg5(clock, weWires[5], ctrl_reset, data_writeReg, regWires[191:160]);
	register reg6(clock, weWires[6], ctrl_reset, data_writeReg, regWires[223:192]);
	register reg7(clock, weWires[7], ctrl_reset, data_writeReg, regWires[255:224]);
	register reg8(clock, weWires[8], ctrl_reset, data_writeReg, regWires[287:256]);
	register reg9(clock, weWires[9], ctrl_reset, data_writeReg, regWires[319:288]);
	register reg10(clock, weWires[10], ctrl_reset, data_writeReg, regWires[351:320]);
	register reg11(clock, weWires[11], ctrl_reset, data_writeReg, regWires[383:352]);
	register reg12(clock, weWires[12], ctrl_reset, data_writeReg, regWires[415:384]);
	register reg13(clock, weWires[13], ctrl_reset, data_writeReg, regWires[447:416]);
	register reg14(clock, weWires[14], ctrl_reset, data_writeReg, regWires[479:448]);
	register reg15(clock, weWires[15], ctrl_reset, data_writeReg, regWires[511:480]);
	register reg16(clock, weWires[16], ctrl_reset, data_writeReg, regWires[543:512]);
	register reg17(clock, weWires[17], ctrl_reset, data_writeReg, regWires[575:544]);
	register reg18(clock, weWires[18], ctrl_reset, data_writeReg, regWires[607:576]);
	register reg19(clock, weWires[19], ctrl_reset, data_writeReg, regWires[639:608]);
	register reg20(clock, weWires[20], ctrl_reset, data_writeReg, regWires[671:640]);
	register reg21(clock, weWires[21], ctrl_reset, data_writeReg, regWires[703:672]);
	register reg22(clock, weWires[22], ctrl_reset, data_writeReg, regWires[735:704]);
	register reg23(clock, weWires[23], ctrl_reset, data_writeReg, regWires[767:736]);
	register reg24(clock, weWires[24], ctrl_reset, data_writeReg, regWires[799:768]);
	register reg25(clock, weWires[25], ctrl_reset, data_writeReg, regWires[831:800]);
	register reg26(clock, weWires[26], ctrl_reset, data_writeReg, regWires[863:832]);
	register reg27(clock, weWires[27], ctrl_reset, data_writeReg, regWires[895:864]);
	register reg28(clock, weWires[28], ctrl_reset, data_writeReg, regWires[927:896]);
	register reg29(clock, weWires[29], ctrl_reset, data_writeReg, regWires[959:928]);
	register reg30(clock, weWires[30], ctrl_reset, data_writeReg, regWires[991:960]);
	register reg31(clock, weWires[31], ctrl_reset, data_writeReg, regWires[1023:992]);
	
	// multiplexors
	
	mux32to1 muxA(ctrl_readRegA, regWires, data_readRegA);
	mux32to1 muxB(ctrl_readRegB, regWires, data_readRegB);
	
	assign regOne = regWires[63:32];

endmodule
