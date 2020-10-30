require 'colorize'

require_relative 'elfdump_parser'
require_relative 'isa'
require_relative 'utils'
require_relative 'disassembler'

module Riscv

  class Iss

    include Utils

    attr_accessor :memory

    def initialize mem_size=2**18
      puts "RISCV ISS - Instruction Set Simulator".center(80,'=')
      puts "warning : this ISS only works _without_ optimizations  (-O0 required for gcc)."
      puts "          Mind that -00 does not produce .text.startup section."
      puts "          ISS is based on this assumption."
      @mem_size=mem_size
      @disassembler=Disassembler.new
      @reg=(0..31).map{|i| [i,0]}.to_h
      @sp=@reg[2]=mem_size-1
    end

    def set_options options
      @options=options
      @disassembler.options=options
    end

    def load_program program
      puts "=> loading #{program.name}"
      @program=program
      create_memory
    end

    def create_memory
      puts " - create ISS memory" if @options[:verbose]
      @memory={}
      @symbolic_memory={}
      text_section=@program.get_section ".text"
      text_section.blocks.each do |block|
        puts "    - dealing with block #{block.label}" if @options[:verbose]
        block.instructions.each do |instr|
          puts instr.inspect
          addr=instr.address.to_i(16)
          @symbolic_memory[addr]=instr
          bin =instr.bin.to_i(16)
          @memory[addr]=bin
        end
      end
      @disassembler.print_memory @memory,@symbolic_memory
    end

    def run
      puts "=> running"
      @nb_instr=0
      exec=@program.get_section ".text"
      main=exec.get_block "<_start>"
      unless main
        raise "ERROR : <_start> label not found."
      else
        puts "<_start> located at : #{main.start_addr}"
        @pc=main.start_addr.to_i(16)
        @running=true
        while @running
          step
          @nb_instr+=1
          puts "pc=0x#{@pc.to_s(16)} (#{@pc})".center(80,'=')
          instruction=fetch()
          decode_execute(instruction)
        end
      end
    end

    def fetch
      puts "instr no #{@nb_instr} : #{@symbolic_memory[@pc].inspect}"
      instruction=@memory[@pc]
      if instruction.nil?
        raise "no instruction at 0x#{@pc.to_s(16)}"
      end
      @pc+=4
      instruction
    end

    def decode_execute instruction
      #puts instruction.to_s(16).rjust(8,'0') if @options[:verbose]
      opcode=instruction & 0b1111111 # 7 bits LSB
      format=ISA::OPCODE_FORMAT_H[opcode]
      field={}
      ISA::FORMAT_ENCODING_H[format].each do |field_name,field_range|
        field[field_name]=bitfield(instruction,field_range)
      end
      puts @disassembler.disassemble(field) if @options[:verbose]
      case opcode=field[:opcode]
      when 0b0110111 #lui
        imm =field[:imm_31_12] << 12
        rd= field[:rd]
        text = [:lui,imm]
        @reg[rd]=imm
      when 0b0010111 #===== U format =====
        imm =field[:imm_31_12] << 12
        text = [:auipc,@pc+imm]
        @reg[rd]=@pc+imm
      when 0b1101111 #===== J format =====
        # JAL
        @pc-=4 #fetch has prepared @pc+=4 already
        imm =field[:imm_20]    << 20
        imm+=field[:imm_10_1]  <<  1
        imm+=field[:imm_11]    << 11
        imm+=field[:imm_19_12] << 12
        imm=(imm-2**21) if imm[20]==1 #signed 21 bits 20...0
        rd= field[:rd]
        @reg[rd]=@pc+4 #in bytes
        @pc+=imm
      when 0b1100111 #===== I format =====
        @pc-=4 #fetch has prepared @pc+=4 already
        imm  = field[:imm_11_0]
        rs1  = field[:rs1]
        rd   = field[:rd]
        text = [:jalr,rd,rs1,imm]
        imm=(imm-2**12) if imm[11]==1
        puts "imm=#{imm}"
        @reg[rd]=@pc+4 #in bytes
        puts "reg#{rs1}=#{@reg[rs1]}"
        @pc=@reg[rs1]+imm
        puts "pc=#{@pc}"
      when 0b1100011 #===== B format =====
        #beq,bne,blt,bge,bltu,bge
        @pc-=4 #fetch has prepared @pc+=4 already
        rs1 =field[:rs1]
        rs2 =field[:rs2]
        imm =field[:imm_12]   << 12
        imm+=field[:imm_10_5] << 5
        imm+=field[:imm_4_1]  << 1
        imm+=field[:imm_11]   << 11
        imm-=2**13 if imm[12]==1
        # sign="+" unless imm < 0
        # imm="pc#{sign}#{imm}"
        #imm=@pc+imm
        case funct3=field[:funct3]
        when 0b000
          text = [:beq,rs1,rs2,imm]
          if sx(@reg[rs1]) == sx(@reg[rs2])
            @pc+=imm
          else
            @pc+=4
          end
        when 0b001
          text = [:bne,rs1,rs2,imm]
          if sx(@reg[rs1]) != sx(@reg[rs2])
            @pc+=imm
          else
            @pc+=4
          end
        when 0b100
          text = [:blt,rs1,rs2,imm]
          if sx(@reg[rs1]) < sx(@reg[rs2])
            @pc+=imm
          else
            @pc+=4
          end
        when 0b101
          text = [:bge,rs1,rs2,imm]
          if sx(@reg[rs1]) >= sx(@reg[rs2])
            @pc+=imm
          else
            @pc+=4
          end
        when 0b110
          text = [:bltu,rs1,rs2,imm]
          if ux(@reg[rs1]) < ux(@reg[rs2])
            @pc+=imm
          else
            @pc+=4
          end
        when 0b111
          text = [:bgeu,rs1,rs2,imm]
          if ux(@reg[rs1]) >= ux(@reg[rs2])
            @pc+=imm
          else
            @pc+=4
          end
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b1100011"
        end
      when 0b0000011 #==== i_type
        imm =field[:imm_11_0]
        imm-=2**12 if imm[11]==1
        rs1 =field[:rs1]
        rd  =field[:rd]
        case funct3=field[:funct3]
        when 0b000 #load byte
          text = [:lb,rd,rs1,imm]
          @reg[rd]=sx(@memory[@reg[rs1]+imm] & 0xFF,8) #load byte, then sign extend to 32, from 8 bits
        when 0b001 #load half word
          text = [:lh,rd,rs1,imm]
          @reg[rd]=sx(@memory[@reg[rs1]+imm] & 0xFFFF,16) #load byte, then sign extend to 32, from 16 bits
        when 0b010
          text = [:lw,rd,rs1,imm]
          puts @reg[rs1].to_s(16)
          puts imm
          addr=@reg[rs1]+imm
          puts "lw @ 0x#{addr.to_s(16)}"
          @reg[rd]=sx(@memory[addr] & 0xFFFFFFFF,32)
        when 0b100
          text = [:lbu,rd,rs1,imm]
          @reg[rd]=ux(@memory[@reg[rs1]+imm] & 0xFF,8) #load byte, then unsigned extend to 32, from 8 bits
        when 0b101
          text = [:lhu,rd,rs1,imm]
          @reg[rd]=ux(@memory[@reg[rs1]+imm] & 0xFFFF,16) #load byte, then unsigned extend to 32, from 16 bits
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b0100011"
        end
        showregs(rd)
      when 0b0100011 #==== s_type
        rs1=field[:rs1]
        rs2=field[:rs2]
        imm=(field[:imm_11_5] << 5) + field[:imm_4_0]
        imm-=2**12 if imm[11]==1
        case funct3=field[:funct3]
        when 0b000
          text = [:sb,rs1,rs2,imm]
          addr=@reg[rs1]+imm
          @memory[addr]=@reg[rs2] & 0xF #u8
        when 0b001
          text = [:sh,rs1,rs2,imm]
          addr=@reg[rs1]+imm
          @memory[addr]=@reg[rs2] & 0xFF #u16
        when 0b010
          text = [:sw,rs1,rs2,imm]
          addr=@reg[rs1]+imm
          @memory[addr]=@reg[rs2] # u32
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b0100011"
        end
        showmem(addr)
      when 0b0010011 #=== i_type
        #addi,slti,sltiu,xori,ori,andi,slli,srli
        rs1=field[:rs1]
        rd =field[:rd]
        imm=field[:imm_11_0]
        imm-=2**12 if imm[11]==1
        case funct3=field[:funct3]
        when 0b000
          text = [:addi,rd,rs1,imm]
          puts "reg[#{rs1}]=0x#{@reg[rs1].to_s(16)}"
          puts "imm=#{imm}(dec)"
          @reg[rd]=(sx(@reg[rs1]) + imm) & 0xFFFFFFFF
        when 0b010
          text = [:slti,rd,rs1,imm]
          @reg[rd]=(sx(@reg[rs1]) < sx(imm)) ? 1 : 0
        when 0b011
          text = [:sltiu,rd,rs1,imm]
          @reg[rd]=(ux(@reg[rs1]) < ux(imm)) ? 1 : 0
        when 0b100
          text = [:xori,rd,rs1,imm]
          @reg[rd]=ux(@reg[rs1]) ^ ux(imm)
        when 0b110
          text = [:ori,rd,rs1,imm]
          @reg[rd]=ux(@reg[rs1]) | ux(imm)
        when 0b111
          text = [:andi,rd,rs1,imm]
          @reg[rd]=ux(@reg[rs1]) & ux(imm)
        when 0b001
          text = [:slli,rd,rs1,imm]
          @reg[rd]=ux(@reg[rs1]) << imm #signed imm ????
        when 0b101
          #srli,srai
          case imm_11_5=(field[:imm_11_0] & 0b1111111) # 7 bits
          when 0b0000000
            text = [:srli,rd,rs1,imm]
            @reg[rd]=ux(@reg[rs1]) >> imm #signed imm ????
          when 0b0100000
            text = [:srai,rd,rs1,imm]
            @reg[rd]=sx(@reg[rs1]) >> imm #signed imm ????
          else
            raise "unknown case for opcode=0b0010011 with func3=0b101"
          end
        else
          raise "unknown funct3 '0b#{funct3.to_s(2)}'"
        end
        showregs(rd)
      when 0b0110011 #r_type
        rs1=field[:rs1]
        rs2=field[:rs2]
        rd =field[:rd]
        case funct3=field[:funct3]
        when 0b000 #add,#sub
          case imm_11_5=field[:funct7]
          when 0b0000000
            text = [:add,rd,rs1,rs2]
            @reg[rd]=(sx(@reg[rs1]) + sx(@reg[rs2])) & 0xFFFFFFFF
          when 0b0100000
            text = [:sub,rd,rs1,rs2]
            @reg[rd]=(sx(@reg[rs1]) - sx(@reg[rs2])) & 0xFFFFFFFF
          else
            raise "unknown case for opcode=0b0110011 with func3=0b000"
          end
        when 0b001
          text = [:sll,rd,rs1,rs2]
          @reg[rd]=ux(@reg[rs1]) << (@reg[rs2] & 0b111111)
        when 0b010
          text = [:slt,rd,rs1,rs2]
          @reg[rd]=(sx(@reg[rs1]) < sx(@reg[rs2])) ? 1 : 0
        when 0b011
          text = [:sltu,rd,rs1,rs2]
          @reg[rd]=(ux(@reg[rs1]) < ux(@reg[rs2])) ? 1 : 0
        when 0b100
          text = [:xor,rd,rs1,rs2]
          @reg[rd]=ux(@reg[rs1]) ^ ux(@reg[rs2])
        when 0b101
          #srl,sra
          case imm_11_5=(field[:imm_11_0] & 0b1111111) # 7 bits
          when 0b0000000
            text = [:srl,rd,rs1,rs2]
            @reg[rd]=ux(@reg[rs1]) >> (@reg[rs2] & 0b111111)
          when 0b0100000
            text = [:sra,rd,rs1,rs2]
            @reg[rd]=sx(@reg[rs1]) >> (@reg[rs2] & 0b111111)
          else
            raise "unknown case for i_type with func3=0b101"
          end
        when 0b110
          text = [:or,rd,rs1,rs2]
          @reg[rd]=ux(@reg[rs1]) | ux(@reg[rs2])
        when 0b111
          text = [:and,rd,rs1,rs2]
          @reg[rd]=ux(@reg[rs1]) & ux(@reg[rs2])
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b0100011"
        end
        showregs(rd)
      when 0b0001111
        #fence, fence.i
      when 0b1100111
        #ecall,ebreak
      when 0b1110011
        #csrrw,etc
      when 0b0110011
        #mul etc
        case funct3=field[:funct3]
        when 0b000
          text = [:mul]
        when 0b001
          text = [:mulh]
        when 0b010
          text = [:mulhsu]
        when 0b011
          text = [:mulhu]
        when 0b100
          text = [:div]
        when 0b101
          text = [:divu]
        when 0b110
          text = [:rem]
        when 0b111
          text = [:remu]
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b0110011"
        end
      else
        puts "unknown opcode '0b#{opcode.to_s(2).rjust(7,'0')}' in #{field}"
      end
      @reg[0]=0 #force
    end
  end
end
