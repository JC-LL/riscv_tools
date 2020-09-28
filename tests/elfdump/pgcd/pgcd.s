
pgcd.x:     format de fichier elf32-littleriscv


Déassemblage de la section .text :

00000000 <pgcd>:
   0:	fe010113          	addi	sp,sp,-32
   4:	00812e23          	sw	s0,28(sp)
   8:	02010413          	addi	s0,sp,32
   c:	fea42623          	sw	a0,-20(s0)
  10:	feb42423          	sw	a1,-24(s0)
  14:	fec42783          	lw	a5,-20(s0)
  18:	0007c663          	blt	a5,zero,24 <.L2>
  1c:	fe842783          	lw	a5,-24(s0)
  20:	0207de63          	bge	a5,zero,5c <.L5>

00000024 <.L2>:
  24:	00000793          	addi	a5,zero,0
  28:	0440006f          	jal	zero,6c <.L4>

0000002c <.L7>:
  2c:	fec42703          	lw	a4,-20(s0)
  30:	fe842783          	lw	a5,-24(s0)
  34:	00e7dc63          	bge	a5,a4,4c <.L6>
  38:	fec42703          	lw	a4,-20(s0)
  3c:	fe842783          	lw	a5,-24(s0)
  40:	40f707b3          	sub	a5,a4,a5
  44:	fef42623          	sw	a5,-20(s0)
  48:	0140006f          	jal	zero,5c <.L5>

0000004c <.L6>:
  4c:	fe842703          	lw	a4,-24(s0)
  50:	fec42783          	lw	a5,-20(s0)
  54:	40f707b3          	sub	a5,a4,a5
  58:	fef42423          	sw	a5,-24(s0)

0000005c <.L5>:
  5c:	fec42703          	lw	a4,-20(s0)
  60:	fe842783          	lw	a5,-24(s0)
  64:	fcf714e3          	bne	a4,a5,2c <.L7>
  68:	fec42783          	lw	a5,-20(s0)

0000006c <.L4>:
  6c:	00078513          	addi	a0,a5,0
  70:	01c12403          	lw	s0,28(sp)
  74:	02010113          	addi	sp,sp,32
  78:	00008067          	jalr	zero,0(ra)

0000007c <main>:
  7c:	fe010113          	addi	sp,sp,-32
  80:	00112e23          	sw	ra,28(sp)
  84:	00812c23          	sw	s0,24(sp)
  88:	02010413          	addi	s0,sp,32
  8c:	4dd00793          	addi	a5,zero,1245
  90:	fef42623          	sw	a5,-20(s0)
  94:	02d00793          	addi	a5,zero,45
  98:	fef42423          	sw	a5,-24(s0)
  9c:	fe842583          	lw	a1,-24(s0)
  a0:	fec42503          	lw	a0,-20(s0)
  a4:	00000097          	auipc	ra,0x0
  a8:	000080e7          	jalr	ra,0(ra) # a4 <main+0x28>
  ac:	fea42223          	sw	a0,-28(s0)
  b0:	fe442683          	lw	a3,-28(s0)
  b4:	fe842603          	lw	a2,-24(s0)
  b8:	fec42583          	lw	a1,-20(s0)
  bc:	000007b7          	lui	a5,0x0
  c0:	00078513          	addi	a0,a5,0 # 0 <pgcd>
  c4:	00000097          	auipc	ra,0x0
  c8:	000080e7          	jalr	ra,0(ra) # c4 <main+0x48>
  cc:	00000793          	addi	a5,zero,0
  d0:	00078513          	addi	a0,a5,0
  d4:	01c12083          	lw	ra,28(sp)
  d8:	01812403          	lw	s0,24(sp)
  dc:	02010113          	addi	sp,sp,32
  e0:	00008067          	jalr	zero,0(ra)
