module control(instruction, j, jal, jr, muxB, dmem, bne, blt, mult, div, bex, setx, should_add, should_subtract);

input [31:0] instruction;

output j, jal, jr, muxB, dmem, bne, blt, mult, div, bex, setx, should_add, should_subtract;

wire [4:0] opcode;

assign opcode = instruction[31:27];

// Jump

wire w1, w2, w3;

and and1(w1, ~opcode[4], ~opcode[3]);
and and2(w2, ~opcode[2], ~opcode[1]);
and and3(w3, opcode[0], w2);
and and4(j, w3, w1);

// Jal

wire w4, w5, w6;

and and5(w4, ~opcode[4], ~opcode[3]);
and and6(w5, ~opcode[2], opcode[1]);
and and7(w6, opcode[0], w5);
and and8(jal, w6, w4);

// Jr

wire w7, w8, w9;

and and9(w7, ~opcode[4], ~opcode[3]);
and and10(w8, opcode[2], ~opcode[1]);
and and11(w9, ~opcode[0], w8);
and and12(jr, w9, w7);

// MuxB

wire w10, w11, w12, w13;

and and13(w10, ~opcode[4], opcode[3]);
and and14(w11, opcode[2], opcode[1], opcode[0]);
and and15(w12, opcode[2], ~opcode[1], opcode[0]);
and and16(w13, ~opcode[4], w12);
or or1(muxB, w10, w11, w13);

// Dmem

or or2(dmem, w10, w11);

// Bne

and and17(bne, ~opcode[2], opcode[1], ~opcode[0]);

// Blt

wire w14;
and and18(w14, opcode[2], opcode[1], ~opcode[0]);
and and19(blt, w14, ~opcode[4]);

// Mult

wire [4:0] aluopcode;
assign aluopcode = instruction[6:2];

wire w15, w16;
and and20(w15, ~aluopcode[4], ~aluopcode[3], aluopcode[2]);
and and21(w16, aluopcode[1], ~aluopcode[0]);
and and22(mult, w15, w16);

// Div

wire w17;
and and23(w17, aluopcode[1], aluopcode[0]);
and and24(div, w15, w17);

// Bex

and and25(bex, w14, opcode[4]);

// Setx

and and26(setx, opcode[4], ~opcode[3], opcode[0]);

// Should_add

wire addi, sw, lw;

and andaddi(addi, ~opcode[4], opcode[2], ~opcode[1], opcode[0]);
and andsw(sw, opcode[2], opcode[1], opcode[0]);
assign lw = opcode[3];

or oraddshould(should_add, addi, sw, lw);

// Should_subtract

or orbranch(should_subtract, bne, blt, bex);

endmodule