
matmult.elf:     format de fichier elf32-littleriscv


Déassemblage de la section .text :

00000000 <multiply>:
   0:	fd010113          	addi	sp,sp,-48
   4:	02112623          	sw	ra,44(sp)
   8:	02812423          	sw	s0,40(sp)
   c:	02912223          	sw	s1,36(sp)
  10:	03010413          	addi	s0,sp,48
  14:	fca42e23          	sw	a0,-36(s0)
  18:	fcb42c23          	sw	a1,-40(s0)
  1c:	fcc42a23          	sw	a2,-44(s0)
  20:	fe042623          	sw	zero,-20(s0)
  24:	15c0006f          	jal	zero,180 <.L2>

00000028 <.L7>:
  28:	fe042423          	sw	zero,-24(s0)
  2c:	13c0006f          	jal	zero,168 <.L3>

00000030 <.L6>:
  30:	fec42703          	lw	a4,-20(s0)
  34:	00070793          	addi	a5,a4,0
  38:	00179793          	slli	a5,a5,0x1
  3c:	00e787b3          	add	a5,a5,a4
  40:	00279793          	slli	a5,a5,0x2
  44:	00078713          	addi	a4,a5,0
  48:	fd442783          	lw	a5,-44(s0)
  4c:	00e78733          	add	a4,a5,a4
  50:	fe842783          	lw	a5,-24(s0)
  54:	00279793          	slli	a5,a5,0x2
  58:	00f707b3          	add	a5,a4,a5
  5c:	0007a023          	sw	zero,0(a5)
  60:	fe042223          	sw	zero,-28(s0)
  64:	0ec0006f          	jal	zero,150 <.L4>

00000068 <.L5>:
  68:	fec42703          	lw	a4,-20(s0)
  6c:	00070793          	addi	a5,a4,0
  70:	00179793          	slli	a5,a5,0x1
  74:	00e787b3          	add	a5,a5,a4
  78:	00279793          	slli	a5,a5,0x2
  7c:	00078713          	addi	a4,a5,0
  80:	fd442783          	lw	a5,-44(s0)
  84:	00e78733          	add	a4,a5,a4
  88:	fe842783          	lw	a5,-24(s0)
  8c:	00279793          	slli	a5,a5,0x2
  90:	00f707b3          	add	a5,a4,a5
  94:	0007a483          	lw	s1,0(a5)
  98:	fec42703          	lw	a4,-20(s0)
  9c:	00070793          	addi	a5,a4,0
  a0:	00179793          	slli	a5,a5,0x1
  a4:	00e787b3          	add	a5,a5,a4
  a8:	00279793          	slli	a5,a5,0x2
  ac:	00078713          	addi	a4,a5,0
  b0:	fdc42783          	lw	a5,-36(s0)
  b4:	00e78733          	add	a4,a5,a4
  b8:	fe442783          	lw	a5,-28(s0)
  bc:	00279793          	slli	a5,a5,0x2
  c0:	00f707b3          	add	a5,a4,a5
  c4:	0007a683          	lw	a3,0(a5)
  c8:	fe442703          	lw	a4,-28(s0)
  cc:	00070793          	addi	a5,a4,0
  d0:	00179793          	slli	a5,a5,0x1
  d4:	00e787b3          	add	a5,a5,a4
  d8:	00279793          	slli	a5,a5,0x2
  dc:	00078713          	addi	a4,a5,0
  e0:	fd842783          	lw	a5,-40(s0)
  e4:	00e78733          	add	a4,a5,a4
  e8:	fe842783          	lw	a5,-24(s0)
  ec:	00279793          	slli	a5,a5,0x2
  f0:	00f707b3          	add	a5,a4,a5
  f4:	0007a783          	lw	a5,0(a5)
  f8:	00078593          	addi	a1,a5,0
  fc:	00068513          	addi	a0,a3,0
 100:	00000097          	auipc	ra,0x0
 104:	000080e7          	jalr	ra,0(ra) # 100 <.L5+0x98>
 108:	00050793          	addi	a5,a0,0
 10c:	00078613          	addi	a2,a5,0
 110:	fec42703          	lw	a4,-20(s0)
 114:	00070793          	addi	a5,a4,0
 118:	00179793          	slli	a5,a5,0x1
 11c:	00e787b3          	add	a5,a5,a4
 120:	00279793          	slli	a5,a5,0x2
 124:	00078713          	addi	a4,a5,0
 128:	fd442783          	lw	a5,-44(s0)
 12c:	00e786b3          	add	a3,a5,a4
 130:	00c48733          	add	a4,s1,a2
 134:	fe842783          	lw	a5,-24(s0)
 138:	00279793          	slli	a5,a5,0x2
 13c:	00f687b3          	add	a5,a3,a5
 140:	00e7a023          	sw	a4,0(a5)
 144:	fe442783          	lw	a5,-28(s0)
 148:	00178793          	addi	a5,a5,1
 14c:	fef42223          	sw	a5,-28(s0)

00000150 <.L4>:
 150:	fe442703          	lw	a4,-28(s0)
 154:	00200793          	addi	a5,zero,2
 158:	f0e7d8e3          	bge	a5,a4,68 <.L5>
 15c:	fe842783          	lw	a5,-24(s0)
 160:	00178793          	addi	a5,a5,1
 164:	fef42423          	sw	a5,-24(s0)

00000168 <.L3>:
 168:	fe842703          	lw	a4,-24(s0)
 16c:	00200793          	addi	a5,zero,2
 170:	ece7d0e3          	bge	a5,a4,30 <.L6>
 174:	fec42783          	lw	a5,-20(s0)
 178:	00178793          	addi	a5,a5,1
 17c:	fef42623          	sw	a5,-20(s0)

00000180 <.L2>:
 180:	fec42703          	lw	a4,-20(s0)
 184:	00200793          	addi	a5,zero,2
 188:	eae7d0e3          	bge	a5,a4,28 <.L7>
 18c:	00000013          	addi	zero,zero,0
 190:	02c12083          	lw	ra,44(sp)
 194:	02812403          	lw	s0,40(sp)
 198:	02412483          	lw	s1,36(sp)
 19c:	03010113          	addi	sp,sp,48
 1a0:	00008067          	jalr	zero,0(ra)

000001a4 <main>:
 1a4:	fa010113          	addi	sp,sp,-96
 1a8:	04112e23          	sw	ra,92(sp)
 1ac:	04812c23          	sw	s0,88(sp)
 1b0:	06010413          	addi	s0,sp,96
 1b4:	000007b7          	lui	a5,0x0
 1b8:	0007a303          	lw	t1,0(a5) # 0 <multiply>
 1bc:	00078713          	addi	a4,a5,0
 1c0:	00472883          	lw	a7,4(a4)
 1c4:	00078713          	addi	a4,a5,0
 1c8:	00872803          	lw	a6,8(a4)
 1cc:	00078713          	addi	a4,a5,0
 1d0:	00c72503          	lw	a0,12(a4)
 1d4:	00078713          	addi	a4,a5,0
 1d8:	01072583          	lw	a1,16(a4)
 1dc:	00078713          	addi	a4,a5,0
 1e0:	01472603          	lw	a2,20(a4)
 1e4:	00078713          	addi	a4,a5,0
 1e8:	01872683          	lw	a3,24(a4)
 1ec:	00078713          	addi	a4,a5,0
 1f0:	01c72703          	lw	a4,28(a4)
 1f4:	00078793          	addi	a5,a5,0
 1f8:	0207a783          	lw	a5,32(a5)
 1fc:	fc642223          	sw	t1,-60(s0)
 200:	fd142423          	sw	a7,-56(s0)
 204:	fd042623          	sw	a6,-52(s0)
 208:	fca42823          	sw	a0,-48(s0)
 20c:	fcb42a23          	sw	a1,-44(s0)
 210:	fcc42c23          	sw	a2,-40(s0)
 214:	fcd42e23          	sw	a3,-36(s0)
 218:	fee42023          	sw	a4,-32(s0)
 21c:	fef42223          	sw	a5,-28(s0)
 220:	fa040793          	addi	a5,s0,-96
 224:	fc440713          	addi	a4,s0,-60
 228:	00078613          	addi	a2,a5,0
 22c:	000007b7          	lui	a5,0x0
 230:	00078593          	addi	a1,a5,0 # 0 <multiply>
 234:	00070513          	addi	a0,a4,0
 238:	00000097          	auipc	ra,0x0
 23c:	000080e7          	jalr	ra,0(ra) # 238 <main+0x94>
 240:	000007b7          	lui	a5,0x0
 244:	00078513          	addi	a0,a5,0 # 0 <multiply>
 248:	00000097          	auipc	ra,0x0
 24c:	000080e7          	jalr	ra,0(ra) # 248 <main+0xa4>
 250:	fe042623          	sw	zero,-20(s0)
 254:	0780006f          	jal	zero,2cc <.L9>

00000258 <.L12>:
 258:	fe042423          	sw	zero,-24(s0)
 25c:	04c0006f          	jal	zero,2a8 <.L10>

00000260 <.L11>:
 260:	fec42703          	lw	a4,-20(s0)
 264:	00070793          	addi	a5,a4,0
 268:	00179793          	slli	a5,a5,0x1
 26c:	00e787b3          	add	a5,a5,a4
 270:	fe842703          	lw	a4,-24(s0)
 274:	00e787b3          	add	a5,a5,a4
 278:	00279793          	slli	a5,a5,0x2
 27c:	ff040713          	addi	a4,s0,-16
 280:	00f707b3          	add	a5,a4,a5
 284:	fb07a783          	lw	a5,-80(a5)
 288:	00078593          	addi	a1,a5,0
 28c:	000007b7          	lui	a5,0x0
 290:	00078513          	addi	a0,a5,0 # 0 <multiply>
 294:	00000097          	auipc	ra,0x0
 298:	000080e7          	jalr	ra,0(ra) # 294 <.L11+0x34>
 29c:	fe842783          	lw	a5,-24(s0)
 2a0:	00178793          	addi	a5,a5,1
 2a4:	fef42423          	sw	a5,-24(s0)

000002a8 <.L10>:
 2a8:	fe842703          	lw	a4,-24(s0)
 2ac:	00200793          	addi	a5,zero,2
 2b0:	fae7d8e3          	bge	a5,a4,260 <.L11>
 2b4:	00a00513          	addi	a0,zero,10
 2b8:	00000097          	auipc	ra,0x0
 2bc:	000080e7          	jalr	ra,0(ra) # 2b8 <.L10+0x10>
 2c0:	fec42783          	lw	a5,-20(s0)
 2c4:	00178793          	addi	a5,a5,1
 2c8:	fef42623          	sw	a5,-20(s0)

000002cc <.L9>:
 2cc:	fec42703          	lw	a4,-20(s0)
 2d0:	00200793          	addi	a5,zero,2
 2d4:	f8e7d2e3          	bge	a5,a4,258 <.L12>
 2d8:	00000793          	addi	a5,zero,0
 2dc:	00078513          	addi	a0,a5,0
 2e0:	05c12083          	lw	ra,92(sp)
 2e4:	05812403          	lw	s0,88(sp)
 2e8:	06010113          	addi	sp,sp,96
 2ec:	00008067          	jalr	zero,0(ra)
