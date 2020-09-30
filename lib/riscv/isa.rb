module Riscv
  module ISA
    ENCODING={
      #========= base instruction formats =========
      r_type:  {
        funct7: 31..25,
        rs2:    24..20,
        rs1:    19..15,
        funct3: 14..12,
        rd:     11..7,
        opcode:  6..0
      },
      i_type: {
        imm_11_0: 31..20,
        rs1:      19..15,
        funct3:   14..12,
        rd:       11..7,
        opcode:    6..0
      },
      s_type: {
        imm_11_5: 31..25,
        rs2:      24..20,
        rs1:      19..15,
        funct3:   14..12,
        imm_4_0:  11..7,
        opcode:    6..0
      },
      b_type: {
        imm_12:    31..31,
        imm_10_5:  30..25,
        rs2:      24..20,
        rs1:      19..15,
        funct3:   14..12,
        imm_4_1:  11..8,
        imm_7:     7..7,
        opcode:    6..0
      },
      u_type: {
        imm_31_12: 31..12,
        rd:        11..7,
        opcode:     6..0
      },
      j_type: {
        imm_20:    31..31,
        imm_10_1:  30..21,
        imm_11:    20..20,
        imm_19_12: 19..12,
        rd:         11..7,
        opcode:      6..0
      },

    }
  end
end
