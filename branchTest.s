nop
addi $r1, $r0, 5
addi $r2, $r0, 10
nop
nop
blt $r1, $r2, branch
dontbranch:
addi $r1, $r0, 2
nop
nop
branch:
addi $r1, $r0, 16
nop
nop
addi $r1, $r0, 12
addi $r2, $r0, 11
nop
nop
bne $r1, $r2, secondNo
nop
nop
nop
nop
secondNo:
addi $r1, $r0, 5
nop
nop
secondYes:
addi $r1, $r0, 203
