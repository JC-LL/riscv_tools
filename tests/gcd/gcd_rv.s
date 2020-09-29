
gcd_rv.x:     format de fichier elf32-littleriscv


Déassemblage de la section .text :

00000000 <gcd>:
   0:	00b50863          	beq	a0,a1,10 <.L2>

00000004 <.L10>:
   4:	00a5d863          	bge	a1,a0,14 <.L3>
   8:	40b50533          	sub	a0,a0,a1
   c:	feb51ce3          	bne	a0,a1,4 <.L10>

00000010 <.L2>:
  10:	00008067          	jalr	zero,0(ra)

00000014 <.L3>:
  14:	40a585b3          	sub	a1,a1,a0
  18:	fe9ff06f          	jal	zero,0 <gcd>
