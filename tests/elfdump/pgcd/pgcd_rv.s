
pgcd_rv.x:     format de fichier elf32-littleriscv


Déassemblage de la section .text :

00000000 <pgcd>:
   0:	00050793          	addi	a5,a0,0
   4:	00000513          	addi	a0,zero,0
   8:	0207ca63          	blt	a5,zero,3c <.L6>
   c:	0205c063          	blt	a1,zero,2c <.L1>
  10:	00b78c63          	beq	a5,a1,28 <.L8>
  14:	00058513          	addi	a0,a1,0

00000018 <.L5>:
  18:	00f55c63          	bge	a0,a5,30 <.L3>
  1c:	40a787b3          	sub	a5,a5,a0
  20:	fea79ce3          	bne	a5,a0,18 <.L5>

00000024 <.L11>:
  24:	00008067          	jalr	zero,0(ra)

00000028 <.L8>:
  28:	00078513          	addi	a0,a5,0

0000002c <.L1>:
  2c:	00008067          	jalr	zero,0(ra)

00000030 <.L3>:
  30:	40f50533          	sub	a0,a0,a5
  34:	fea792e3          	bne	a5,a0,18 <.L5>
  38:	fedff06f          	jal	zero,24 <.L11>

0000003c <.L6>:
  3c:	00008067          	jalr	zero,0(ra)

Déassemblage de la section .text.startup :

00000000 <main>:
   0:	ff010113          	addi	sp,sp,-16
   4:	00112623          	sw	ra,12(sp)
   8:	02d00693          	addi	a3,zero,45
   c:	4dd00793          	addi	a5,zero,1245

00000010 <.L15>:
  10:	02f6da63          	bge	a3,a5,44 <.L13>
  14:	40d787b3          	sub	a5,a5,a3
  18:	fef69ce3          	bne	a3,a5,10 <.L15>

0000001c <.L18>:
  1c:	00000537          	lui	a0,0x0
  20:	02d00613          	addi	a2,zero,45
  24:	4dd00593          	addi	a1,zero,1245
  28:	00050513          	addi	a0,a0,0 # 0 <main>
  2c:	00000097          	auipc	ra,0x0
  30:	000080e7          	jalr	ra,0(ra) # 2c <.L18+0x10>
  34:	00c12083          	lw	ra,12(sp)
  38:	00000513          	addi	a0,zero,0
  3c:	01010113          	addi	sp,sp,16
  40:	00008067          	jalr	zero,0(ra)

00000044 <.L13>:
  44:	40f686b3          	sub	a3,a3,a5
  48:	fcf694e3          	bne	a3,a5,10 <.L15>
  4c:	fd1ff06f          	jal	zero,1c <.L18>
