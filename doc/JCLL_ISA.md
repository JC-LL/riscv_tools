# Instruction set architecture

## Opcodes

format of a line in this file:
\<instruction name> <args> <opcode>

\<opcode> is given by specifying one or more range/value pairs:
hi..lo=value or bit=value or arg=value (e.g. 6..2=0x45 10=1 rd=0)

\<args> is one of rd, rs1, rs2, rs3, imm20, imm12, imm12lo, imm12hi,
shamtw, shamt, rm

- **beq**     bimm12hi rs1 rs2 bimm12lo 14..12=0 6..2=0x18 1..0=3
- **bne**     bimm12hi rs1 rs2 bimm12lo 14..12=1 6..2=0x18 1..0=3
- **blt**     bimm12hi rs1 rs2 bimm12lo 14..12=4 6..2=0x18 1..0=3
- **bge**     bimm12hi rs1 rs2 bimm12lo 14..12=5 6..2=0x18 1..0=3
- **bltu**    bimm12hi rs1 rs2 bimm12lo 14..12=6 6..2=0x18 1..0=3
- **bgeu**    bimm12hi rs1 rs2 bimm12lo 14..12=7 6..2=0x18 1..0=3

- **jalr**    rd rs1 imm12              14..12=0 6..2=0x19 1..0=3

- **jal**     rd jimm20                          6..2=0x1b 1..0=3

- **lui**     rd imm20 6..2=0x0D 1..0=3
- **auipc**   rd imm20 6..2=0x05 1..0=3

- **addi**    rd rs1 imm12           14..12=0 6..2=0x04 1..0=3
- **slli**    rd rs1 31..26=0  shamt 14..12=1 6..2=0x04 1..0=3
- **slti**    rd rs1 imm12           14..12=2 6..2=0x04 1..0=3
- **sltiu**   rd rs1 imm12           14..12=3 6..2=0x04 1..0=3
- **xori**    rd rs1 imm12           14..12=4 6..2=0x04 1..0=3
- **srli**    rd rs1 31..26=0  shamt 14..12=5 6..2=0x04 1..0=3
- **srai**    rd rs1 31..26=16 shamt 14..12=5 6..2=0x04 1..0=3
- **ori**     rd rs1 imm12           14..12=6 6..2=0x04 1..0=3
- **andi**    rd rs1 imm12           14..12=7 6..2=0x04 1..0=3

- **add**     rd rs1 rs2 31..25=0  14..12=0 6..2=0x0C 1..0=3
- **sub**     rd rs1 rs2 31..25=32 14..12=0 6..2=0x0C 1..0=3
- **sll**     rd rs1 rs2 31..25=0  14..12=1 6..2=0x0C 1..0=3
- **slt**    rd rs1 rs2 31..25=0  14..12=2 6..2=0x0C 1..0=3
- **sltu**    rd rs1 rs2 31..25=0  14..12=3 6..2=0x0C 1..0=3
- **xor**     rd rs1 rs2 31..25=0  14..12=4 6..2=0x0C 1..0=3
- **srl**     rd rs1 rs2 31..25=0  14..12=5 6..2=0x0C 1..0=3
- **sra**     rd rs1 rs2 31..25=32 14..12=5 6..2=0x0C 1..0=3
- **or**      rd rs1 rs2 31..25=0  14..12=6 6..2=0x0C 1..0=3
- **and**     rd rs1 rs2 31..25=0  14..12=7 6..2=0x0C 1..0=3

- **addiw**   rd rs1 imm12            14..12=0 6..2=0x06 1..0=3
- **slliw**   rd rs1 31..25=0  shamtw 14..12=1 6..2=0x06 1..0=3
- **srliw**   rd rs1 31..25=0  shamtw 14..12=5 6..2=0x06 1..0=3
- **sraiw**   rd rs1 31..25=32 shamtw 14..12=5 6..2=0x06 1..0=3

- **addw**    rd rs1 rs2 31..25=0  14..12=0 6..2=0x0E 1..0=3
- **subw**    rd rs1 rs2 31..25=32 14..12=0 6..2=0x0E 1..0=3
- **sllw**    rd rs1 rs2 31..25=0  14..12=1 6..2=0x0E 1..0=3
- **srlw**    rd rs1 rs2 31..25=0  14..12=5 6..2=0x0E 1..0=3
- **sraw**    rd rs1 rs2 31..25=32 14..12=5 6..2=0x0E 1..0=3

- **lb**      rd rs1       imm12 14..12=0 6..2=0x00 1..0=3
- **lh**      rd rs1       imm12 14..12=1 6..2=0x00 1..0=3
- **lw**      rd rs1       imm12 14..12=2 6..2=0x00 1..0=3
- **ld**      rd rs1       imm12 14..12=3 6..2=0x00 1..0=3
- **lbu**     rd rs1       imm12 14..12=4 6..2=0x00 1..0=3
- **lhu**     rd rs1       imm12 14..12=5 6..2=0x00 1..0=3
- **lwu**     rd rs1       imm12 14..12=6 6..2=0x00 1..0=3

- **sb**     imm12hi rs1 rs2 imm12lo 14..12=0 6..2=0x08 1..0=3
- **sh**     imm12hi rs1 rs2 imm12lo 14..12=1 6..2=0x08 1..0=3
- **sw**     imm12hi rs1 rs2 imm12lo 14..12=2 6..2=0x08 1..0=3
- **sd**     imm12hi rs1 rs2 imm12lo 14..12=3 6..2=0x08 1..0=3

- **fence**       fm            pred succ     rs1 14..12=0 rd 6..2=0x03 1..0=3
- **fence.i**s     imm12                       rs1 14..12=1 rd 6..2=0x03 1..0=3

# RV32M
- **mul**     rd rs1 rs2 31..25=1 14..12=0 6..2=0x0C 1..0=3
- **mulh**    rd rs1 rs2 31..25=1 14..12=1 6..2=0x0C 1..0=3
- **mulhsu**  rd rs1 rs2 31..25=1 14..12=2 6..2=0x0C 1..0=3
- **mulhu**   rd rs1 rs2 31..25=1 14..12=3 6..2=0x0C 1..0=3
- **div**     rd rs1 rs2 31..25=1 14..12=4 6..2=0x0C 1..0=3
- **divu**    rd rs1 rs2 31..25=1 14..12=5 6..2=0x0C 1..0=3
- **rem**     rd rs1 rs2 31..25=1 14..12=6 6..2=0x0C 1..0=3
- **remu**    rd rs1 rs2 31..25=1 14..12=7 6..2=0x0C 1..0=3

# RV64M
- **mulw**    rd rs1 rs2 31..25=1 14..12=0 6..2=0x0E 1..0=3
- **divw**    rd rs1 rs2 31..25=1 14..12=4 6..2=0x0E 1..0=3
- **divuw**   rd rs1 rs2 31..25=1 14..12=5 6..2=0x0E 1..0=3
- **remw**    rd rs1 rs2 31..25=1 14..12=6 6..2=0x0E 1..0=3
- **remuw**   rd rs1 rs2 31..25=1 14..12=7 6..2=0x0E 1..0=3

# RV32A
- **amoadd.w**    rd rs1 rs2      aqrl 31..29=0 28..27=0 14..12=2 6..2=0x0B 1..0=3
- **amoxor.w**    rd rs1 rs2      aqrl 31..29=1 28..27=0 14..12=2 6..2=0x0B 1..0=3
- **amoor.w**     rd rs1 rs2      aqrl 31..29=2 28..27=0 14..12=2 6..2=0x0B 1..0=3
- **amoand.w**    rd rs1 rs2      aqrl 31..29=3 28..27=0 14..12=2 6..2=0x0B 1..0=3
- **amomin.w**    rd rs1 rs2      aqrl 31..29=4 28..27=0 14..12=2 6..2=0x0B 1..0=3
- **amomax.w**    rd rs1 rs2      aqrl 31..29=5 28..27=0 14..12=2 6..2=0x0B 1..0=3
- **amominu.w**   rd rs1 rs2      aqrl 31..29=6 28..27=0 14..12=2 6..2=0x0B 1..0=3
- **amomaxu.w**   rd rs1 rs2      aqrl 31..29=7 28..27=0 14..12=2 6..2=0x0B 1..0=3
- **amoswap.w**   rd rs1 rs2      aqrl 31..29=0 28..27=1 14..12=2 6..2=0x0B 1..0=3
- **lr.w**        rd rs1 24..20=0 aqrl 31..29=0 28..27=2 14..12=2 6..2=0x0B 1..0=3
- **sc.w**        rd rs1 rs2      aqrl 31..29=0 28..27=3 14..12=2 6..2=0x0B 1..0=3

# RV64A
- **amoadd.d**    rd rs1 rs2      aqrl 31..29=0 28..27=0 14..12=3 6..2=0x0B 1..0=3
- **amoxor.d**    rd rs1 rs2      aqrl 31..29=1 28..27=0 14..12=3 6..2=0x0B 1..0=3
- **amoor.d**    rd rs1 rs2      aqrl 31..29=2 28..27=0 14..12=3 6..2=0x0B 1..0=3
- **amoand.d**    rd rs1 rs2      aqrl 31..29=3 28..27=0 14..12=3 6..2=0x0B 1..0=3
- **amomin.d**    rd rs1 rs2      aqrl 31..29=4 28..27=0 14..12=3 6..2=0x0B 1..0=3
- **amomax.d**    rd rs1 rs2      aqrl 31..29=5 28..27=0 14..12=3 6..2=0x0B 1..0=3
- **amominu.d**   rd rs1 rs2      aqrl 31..29=6 28..27=0 14..12=3 6..2=0x0B 1..0=3
- **amomaxu.d**   rd rs1 rs2      aqrl 31..29=7 28..27=0 14..12=3 6..2=0x0B 1..0=3
- **amoswap.d**   rd rs1 rs2      aqrl 31..29=0 28..27=1 14..12=3 6..2=0x0B 1..0=3
- **lr.d**        rd rs1 24..20=0 aqrl 31..29=0 28..27=2 14..12=3 6..2=0x0B 1..0=3
- **sc.d**        rd rs1 rs2      aqrl 31..29=0 28..27=3 14..12=3 6..2=0x0B 1..0=3

# SYSTEM
- **ecall**     11..7=0 19..15=0 31..20=0x000 14..12=0 6..2=0x1C 1..0=3
- **ebreak**    11..7=0 19..15=0 31..20=0x001 14..12=0 6..2=0x1C 1..0=3
- **uret**      11..7=0 19..15=0 31..20=0x002 14..12=0 6..2=0x1C 1..0=3
- **sret**      11..7=0 19..15=0 31..20=0x102 14..12=0 6..2=0x1C 1..0=3
- **mret**      11..7=0 19..15=0 31..20=0x302 14..12=0 6..2=0x1C 1..0=3
- **dret**      11..7=0 19..15=0 31..20=0x7b2 14..12=0 6..2=0x1C 1..0=3
- **sfence.vma** 11..7=0 rs1 rs2 31..25=0x09  14..12=0 6..2=0x1C 1..0=3
- **wfi**       11..7=0 19..15=0 31..20=0x105 14..12=0 6..2=0x1C 1..0=3
- **csrrw**     rd      rs1      imm12        14..12=1 6..2=0x1C 1..0=3
- **csrrs**     rd      rs1      imm12        14..12=2 6..2=0x1C 1..0=3
- **csrrc**     rd      rs1      imm12        14..12=3 6..2=0x1C 1..0=3
- **csrrwi**    rd      rs1      imm12        14..12=5 6..2=0x1C 1..0=3
- **csrrsi**    rd      rs1      imm12        14..12=6 6..2=0x1C 1..0=3
- **csrrci**    rd      rs1      imm12        14..12=7 6..2=0x1C 1..0=3

# Hypervisor extension
- **hfence.bvma** 11..7=0 rs1 rs2 31..25=0x11  14..12=0 6..2=0x1C 1..0=3
- **hfence.gvma** 11..7=0 rs1 rs2 31..25=0x51  14..12=0 6..2=0x1C 1..0=3

# F/D EXTENSIONS
- **fadd.s**    rd rs1 rs2      31..27=0x00 rm       26..25=0 6..2=0x14 1..0=3
- **fsub.s**    rd rs1 rs2      31..27=0x01 rm       26..25=0 6..2=0x14 1..0=3
- **fmul.s**    rd rs1 rs2      31..27=0x02 rm       26..25=0 6..2=0x14 1..0=3
- **fdiv.s**    rd rs1 rs2      31..27=0x03 rm       26..25=0 6..2=0x14 1..0=3
- **fsgnj.s**   rd rs1 rs2      31..27=0x04 14..12=0 26..25=0 6..2=0x14 1..0=3
- **fsgnjn.s**  rd rs1 rs2      31..27=0x04 14..12=1 26..25=0 6..2=0x14 1..0=3
- **fsgnjx.s**  rd rs1 rs2      31..27=0x04 14..12=2 26..25=0 6..2=0x14 1..0=3
- **fmin.s**    rd rs1 rs2      31..27=0x05 14..12=0 26..25=0 6..2=0x14 1..0=3
- **fmax.s**    rd rs1 rs2      31..27=0x05 14..12=1 26..25=0 6..2=0x14 1..0=3
- **fsqrt.s**   rd rs1 24..20=0 31..27=0x0B rm       26..25=0 6..2=0x14 1..0=3

_ fadd.d    rd rs1 rs2      31..27=0x00 rm       26..25=1 6..2=0x14 1..0=3
_ fsub.d    rd rs1 rs2      31..27=0x01 rm       26..25=1 6..2=0x14 1..0=3
_ fmul.d    rd rs1 rs2      31..27=0x02 rm       26..25=1 6..2=0x14 1..0=3
_ fdiv.d    rd rs1 rs2      31..27=0x03 rm       26..25=1 6..2=0x14 1..0=3
_ fsgnj.d   rd rs1 rs2      31..27=0x04 14..12=0 26..25=1 6..2=0x14 1..0=3
_ fsgnjn.d  rd rs1 rs2      31..27=0x04 14..12=1 26..25=1 6..2=0x14 1..0=3
_ fsgnjx.d  rd rs1 rs2      31..27=0x04 14..12=2 26..25=1 6..2=0x14 1..0=3
_ fmin.d    rd rs1 rs2      31..27=0x05 14..12=0 26..25=1 6..2=0x14 1..0=3
_ fmax.d    rd rs1 rs2      31..27=0x05 14..12=1 26..25=1 6..2=0x14 1..0=3
_ fcvt.s.d  rd rs1 24..20=1 31..27=0x08 rm       26..25=0 6..2=0x14 1..0=3
_ fcvt.d.s  rd rs1 24..20=0 31..27=0x08 rm       26..25=1 6..2=0x14 1..0=3
_ fsqrt.d   rd rs1 24..20=0 31..27=0x0B rm       26..25=1 6..2=0x14 1..0=3

- fadd.q    rd rs1 rs2      31..27=0x00 rm       26..25=3 6..2=0x14 1..0=3
- fsub.q    rd rs1 rs2      31..27=0x01 rm       26..25=3 6..2=0x14 1..0=3
- fmul.q    rd rs1 rs2      31..27=0x02 rm       26..25=3 6..2=0x14 1..0=3
- fdiv.q    rd rs1 rs2      31..27=0x03 rm       26..25=3 6..2=0x14 1..0=3
- fsgnj.q   rd rs1 rs2      31..27=0x04 14..12=0 26..25=3 6..2=0x14 1..0=3
- fsgnjn.q  rd rs1 rs2      31..27=0x04 14..12=1 26..25=3 6..2=0x14 1..0=3
- fsgnjx.q  rd rs1 rs2      31..27=0x04 14..12=2 26..25=3 6..2=0x14 1..0=3
- fmin.q    rd rs1 rs2      31..27=0x05 14..12=0 26..25=3 6..2=0x14 1..0=3
- fmax.q    rd rs1 rs2      31..27=0x05 14..12=1 26..25=3 6..2=0x14 1..0=3
- fcvt.s.q  rd rs1 24..20=3 31..27=0x08 rm       26..25=0 6..2=0x14 1..0=3
- fcvt.q.s  rd rs1 24..20=0 31..27=0x08 rm       26..25=3 6..2=0x14 1..0=3
- fcvt.d.q  rd rs1 24..20=3 31..27=0x08 rm       26..25=1 6..2=0x14 1..0=3
- fcvt.q.d  rd rs1 24..20=1 31..27=0x08 rm       26..25=3 6..2=0x14 1..0=3
- fsqrt.q   rd rs1 24..20=0 31..27=0x0B rm       26..25=3 6..2=0x14 1..0=3

- **fle.s     rd rs1 rs2      31..27=0x14 14..12=0 26..25=0 6..2=0x14 1..0=3
- **flt.s     rd rs1 rs2      31..27=0x14 14..12=1 26..25=0 6..2=0x14 1..0=3
- **feq.s     rd rs1 rs2      31..27=0x14 14..12=2 26..25=0 6..2=0x14 1..0=3
- **
- **fle.d     rd rs1 rs2      31..27=0x14 14..12=0 26..25=1 6..2=0x14 1..0=3
- **flt.d     rd rs1 rs2      31..27=0x14 14..12=1 26..25=1 6..2=0x14 1..0=3
- **feq.d     rd rs1 rs2      31..27=0x14 14..12=2 26..25=1 6..2=0x14 1..0=3
- **
- **fle.q     rd rs1 rs2      31..27=0x14 14..12=0 26..25=3 6..2=0x14 1..0=3
- **flt.q     rd rs1 rs2      31..27=0x14 14..12=1 26..25=3 6..2=0x14 1..0=3
- **feq.q     rd rs1 rs2      31..27=0x14 14..12=2 26..25=3 6..2=0x14 1..0=3
- **
- **fcvt.w.s  rd rs1 24..20=0 31..27=0x18 rm       26..25=0 6..2=0x14 1..0=3
- **fcvt.wu.s rd rs1 24..20=1 31..27=0x18 rm       26..25=0 6..2=0x14 1..0=3
- **fcvt.l.s  rd rs1 24..20=2 31..27=0x18 rm       26..25=0 6..2=0x14 1..0=3
- **fcvt.lu.s rd rs1 24..20=3 31..27=0x18 rm       26..25=0 6..2=0x14 1..0=3
- **fmv.x.w   rd rs1 24..20=0 31..27=0x1C 14..12=0 26..25=0 6..2=0x14 1..0=3
- **fclass.s  rd rs1 24..20=0 31..27=0x1C 14..12=1 26..25=0 6..2=0x14 1..0=3
- **
- **fcvt.w.d  rd rs1 24..20=0 31..27=0x18 rm       26..25=1 6..2=0x14 1..0=3
- **fcvt.wu.d rd rs1 24..20=1 31..27=0x18 rm       26..25=1 6..2=0x14 1..0=3
- **fcvt.l.d  rd rs1 24..20=2 31..27=0x18 rm       26..25=1 6..2=0x14 1..0=3
- **fcvt.lu.d rd rs1 24..20=3 31..27=0x18 rm       26..25=1 6..2=0x14 1..0=3
- **fmv.x.d   rd rs1 24..20=0 31..27=0x1C 14..12=0 26..25=1 6..2=0x14 1..0=3
- **fclass.d  rd rs1 24..20=0 31..27=0x1C 14..12=1 26..25=1 6..2=0x14 1..0=3
- **
- **fcvt.w.q  rd rs1 24..20=0 31..27=0x18 rm       26..25=3 6..2=0x14 1..0=3
- **fcvt.wu.q rd rs1 24..20=1 31..27=0x18 rm       26..25=3 6..2=0x14 1..0=3
- **fcvt.l.q  rd rs1 24..20=2 31..27=0x18 rm       26..25=3 6..2=0x14 1..0=3
- **fcvt.lu.q rd rs1 24..20=3 31..27=0x18 rm       26..25=3 6..2=0x14 1..0=3
- **fmv.x.q   rd rs1 24..20=0 31..27=0x1C 14..12=0 26..25=3 6..2=0x14 1..0=3
- **fclass.q  rd rs1 24..20=0 31..27=0x1C 14..12=1 26..25=3 6..2=0x14 1..0=3
- **
- **fcvt.s.w  rd rs1 24..20=0 31..27=0x1A rm       26..25=0 6..2=0x14 1..0=3
- **fcvt.s.wu rd rs1 24..20=1 31..27=0x1A rm       26..25=0 6..2=0x14 1..0=3
- **fcvt.s.l  rd rs1 24..20=2 31..27=0x1A rm       26..25=0 6..2=0x14 1..0=3
- **fcvt.s.lu rd rs1 24..20=3 31..27=0x1A rm       26..25=0 6..2=0x14 1..0=3
- **fmv.w.x   rd rs1 24..20=0 31..27=0x1E 14..12=0 26..25=0 6..2=0x14 1..0=3
- **
- **fcvt.d.w  rd rs1 24..20=0 31..27=0x1A rm       26..25=1 6..2=0x14 1..0=3
- **fcvt.d.wu rd rs1 24..20=1 31..27=0x1A rm       26..25=1 6..2=0x14 1..0=3
- **fcvt.d.l  rd rs1 24..20=2 31..27=0x1A rm       26..25=1 6..2=0x14 1..0=3
- **fcvt.d.lu rd rs1 24..20=3 31..27=0x1A rm       26..25=1 6..2=0x14 1..0=3
- **fmv.d.x   rd rs1 24..20=0 31..27=0x1E 14..12=0 26..25=1 6..2=0x14 1..0=3
- **
- **fcvt.q.w  rd rs1 24..20=0 31..27=0x1A rm       26..25=3 6..2=0x14 1..0=3
- **fcvt.q.wu rd rs1 24..20=1 31..27=0x1A rm       26..25=3 6..2=0x14 1..0=3
- **fcvt.q.l  rd rs1 24..20=2 31..27=0x1A rm       26..25=3 6..2=0x14 1..0=3
- **fcvt.q.lu rd rs1 24..20=3 31..27=0x1A rm       26..25=3 6..2=0x14 1..0=3
- **fmv.q.x   rd rs1 24..20=0 31..27=0x1E 14..12=0 26..25=3 6..2=0x14 1..0=3
- **
- **flw       rd rs1 imm12 14..12=2 6..2=0x01 1..0=3
- **fld       rd rs1 imm12 14..12=3 6..2=0x01 1..0=3
- **flq       rd rs1 imm12 14..12=4 6..2=0x01 1..0=3
- **
- **fsw       imm12hi rs1 rs2 imm12lo 14..12=2 6..2=0x09 1..0=3
- **fsd       imm12hi rs1 rs2 imm12lo 14..12=3 6..2=0x09 1..0=3
- **fsq       imm12hi rs1 rs2 imm12lo 14..12=4 6..2=0x09 1..0=3
- **
- **fmadd.s   rd rs1 rs2 rs3 rm 26..25=0 6..2=0x10 1..0=3
- **fmsub.s   rd rs1 rs2 rs3 rm 26..25=0 6..2=0x11 1..0=3
- **fnmsub.s  rd rs1 rs2 rs3 rm 26..25=0 6..2=0x12 1..0=3
- **fnmadd.s  rd rs1 rs2 rs3 rm 26..25=0 6..2=0x13 1..0=3
- **
- **fmadd.d   rd rs1 rs2 rs3 rm 26..25=1 6..2=0x10 1..0=3
- **fmsub.d   rd rs1 rs2 rs3 rm 26..25=1 6..2=0x11 1..0=3
- **fnmsub.d  rd rs1 rs2 rs3 rm 26..25=1 6..2=0x12 1..0=3
- **fnmadd.d  rd rs1 rs2 rs3 rm 26..25=1 6..2=0x13 1..0=3
- **
- **fmadd.q   rd rs1 rs2 rs3 rm 26..25=3 6..2=0x10 1..0=3
- **fmsub.q   rd rs1 rs2 rs3 rm 26..25=3 6..2=0x11 1..0=3
- **fnmsub.q  rd rs1 rs2 rs3 rm 26..25=3 6..2=0x12 1..0=3
- **fnmadd.q  rd rs1 rs2 rs3 rm 26..25=3 6..2=0x13 1..0=3