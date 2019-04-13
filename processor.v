/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,                   // I: Data from port B of regfile
	 pc,
	 weT,
	 target_pc,
	 next_pc,
	 branch,
	 execute_pc,
	 ilt,
	 aluResult,
	 aluA,
	 aluB
);
    // Control signals
    input clock, reset;
	 
	 output [31:0] pc;
	 output weT;
	 
	 assign weT = writeback_we;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 
	 /*** Fetch ***/
	 	 
	 wire [31:0] jump, no_jr;
	 wire [26:0] target;
	 
	 output [31:0] next_pc, branch;
	 
	 wire didBranch;
	 assign didBranch = jumpOrJalOrBex | should_branch;
	 
	 register program_counter(clock, 1'b1, reset, next_pc, pc);
	 
	 assign address_imem = pc[11:0];
	 
	 assign next_pc = jr ? data_readRegA : no_jr;
	 
	 wire jumpOrJalOrBex, shouldBex;
	 or jorj(jumpOrJalOrBex, jf, jalf, shouldBex);
	 
	 output [31:0] target_pc;
	 assign target_pc = targetf;
	 
	 assign no_jr = jumpOrJalOrBex ? target_pc : branch;
	 
	 wire [31:0] pc_plus_one, sx_immediate, pc_plus_one_plus_imm;
	 wire neq, lt, ovf, neq2, lt2, ovf2;
	 
	 alu pc_plus_one_alu(pc, 32'b1, 5'b0, 5'b0, pc_plus_one, neq, lt, ovf);
	 csa32 pc_plus_one_plus_imm_adder(execute_pc, sx_immediate, 1'b0, pc_plus_one_plus_imm, neq2, lt2);
	 
	 wire should_branch;
	 assign branch = should_branch ? pc_plus_one_plus_imm : pc_plus_one;
	 
	 wire jf, jalf, jrf, muxBf, dmemf, bnef, bltf, multf, divf, bexf, setxf, should_addf, should_subtractf;
	 control fetch_ctrl(q_imem, jf, jalf, jrf, muxBf, dmemf, bnef, bltf, multf, divf, bexf, setxf, should_addf, should_subtractf);
	 
	 wire [4:0] rdf, rd_writebackf, rsf, rtf, shamtf, aluopf;
	 wire [16:0] immediatef;
	 wire [26:0] targetf;
	 
	 insn_signals fetch_signals(q_imem, rdf, rsf, rtf, shamtf, aluopf, immediatef, targetf);
	 
	 // F/D Latch 
	 wire [31:0] decode_pc, decode_insn;
	 fetch_decode fd(~clock, 1'b1, (didBranch | reset), pc, q_imem, decode_pc, decode_insn);
	 
	 /** Decode **/
	 
	 wire [4:0] rd, rd_writeback, rs, rt, shamt, aluop;
	 wire [16:0] immediate;
	 
	 insn_signals decode_signals(decode_insn, rd, rs, rt, shamt, aluop, immediate, target);
	 	 
	 wire [4:0] x1, x2, x3;
	 
	 wire jd, jald, jrd, muxBd, dmemd, bned, bltd, multd, divd, bexd, setxd, should_addd, should_subtractd;
	 control decode_ctrl(decode_insn, jd, jald, jrd, muxBd, dmemd, bned, bltd, multd, divd, bexd, setxd, should_addd, should_subtractd);
	 
	 assign x1 = (bned | bltd) ? rd : rs;
	 assign x2 = (bned | bltd) ? rs : rt;
	 assign x3 = jalx ? 5'b11111 : rd_writeback;
	 
	 assign ctrl_writeEnable = writeback_we;
	 assign ctrl_writeReg = setxx ? 5'b11110 : x3;
	 assign ctrl_readRegA = bexd ? 5'b11110 : x1;
	 assign ctrl_readRegB = bexd ? 5'b00000 : x2;
	 
	 // D/X Latch
	 wire [31:0] execute_dataA, execute_dataB, execute_insn, actual_insn;
	 output [31:0] execute_pc;
	 
	 decode_execute dx(~clock, (didBranch | reset), data_readRegA, data_readRegB, decode_insn, decode_pc, execute_dataA, execute_dataB, execute_insn, execute_pc);
	 
	 // Execute
	 
	 wire [4:0] rd2, rs2, rt2, shamt2, aluop2;
	 wire [16:0] immediate2;
	 wire [26:0] target2;
	 
	 insn_signals execute_signals(execute_insn, rd2, rs2, rt2, shamt2, aluop2, immediate2, target2);
	 
	 wire j, jal, jr, muxB, dmem, bne, blt, mult, div, bex, setx, should_add, should_subtract;
	 control control_unit(execute_insn, j, jal, jr, muxB, dmem, bne, blt, mult, div, bex, setx, should_add, should_subtract);
	 
	 wire [31:0] aluDataB, alu_add, alu_sub;
	 output [31:0] aluResult;
	 wire ine, eovf;
	 output ilt;
	 
	 assign alu_add = should_add ? 5'b0 : aluop2;
	 assign alu_sub = should_subtract ? 5'b00001 : alu_add;
	 
	 output [31:0] aluA, aluB;
	 
	 assign aluA = execute_dataA;
	 assign aluB = aluDataB;
 	 
	 alu execute_alu(execute_dataA, aluDataB, alu_sub, shamt2, aluResult, ine, ilt, eovf);
	 
	 wire shouldBlt, shouldBne;
	 and bltAnd(shouldBlt, blt, ilt);
	 and bneAnd(shouldBne, bne, ine);
	 or orBranch(should_branch, shouldBlt, shouldBne);
	 
	 and andBex(shouldBex, bex, ine);
	 
	 sx sign_extender(immediate2, sx_immediate);
	 
	 assign aluDataB = muxB ? sx_immediate : execute_dataB;

	 // X/M Latch
	 wire [31:0] alu_out, alu_in_B, memory_insn;
	 wire dmem_wren;
	 execute_memory xm(~clock, reset, aluResult, aluInB7, execute_insn, dmem, alu_out, alu_in_B, memory_insn, dmem_wren);
	 
	 /** Memory **/
	 
	 assign address_dmem = alu_out[11:0];
	 assign wren = dmem_wren;
	 assign data = alu_in_B;
	 	 
	 // M/W Latch
	 wire [31:0] alu_out2, dmem_out2, writeback_insn;
	 memory_writeback mw(~clock, reset, alu_out, q_dmem, memory_insn, alu_out2, dmem_out2, writeback_insn);
	 
	 // Writeback
	 
	 assign rd_writeback = writeback_insn[26:22];
	 
	 wire [4:0] writeback_opcode;
	 assign writeback_opcode = writeback_insn[31:27];
	 
	 wire lw;
	 assign lw = writeback_opcode[3];
	 
	 wire [31:0] regfile_data_write, x69;
	 assign regfile_data_write = lw ? dmem_out2 : alu_out2;
	 
	 // Write PC - 3 to $r31 for jal
	 wire jalSum, jalc, jalc2;
	 csa32 pc_minus_3(pc, 32'b11111111111111111111111111111101, 1'b0, jalSum, jalc, jalc2);
	 
	 assign data_writeReg = jalx ? jalSum : regfile_data_write;
	 	 
	 wire is_alu_op, t1, t2, t3, t4;
	 and andt1(t1, ~writeback_opcode[4], ~writeback_opcode[3], ~writeback_opcode[2]);
	 and andt2(t2, ~writeback_opcode[1], ~writeback_opcode[0]);
	 and isALUop(is_alu_op, t1, t2);
	 and and101(t3, writeback_opcode[2], ~writeback_opcode[1], writeback_opcode[0]);
	 and and011(t4, ~writeback_opcode[2], writeback_opcode[1], writeback_opcode[0]);
	 
	 wire writeback_we;
	 or orWe(writeback_we, is_alu_op, t3, t4, lw);
	 
	 wire jx, jalx, jrx, muxBx, dmemx, bnex, bltx, multx, divx, bexx, setxx, should_addx, should_subtractx;
	 control wb_ctrl(writeback_insn, jx, jalx, jrx, muxBx, dmemx, bnex, bltx, multx, divx, bexx, setxx, should_addx, should_subtractx);
	 
endmodule
