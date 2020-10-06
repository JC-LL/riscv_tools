require_relative 'elfdump_parser'
require_relative 'isa'
require 'colorize'
module Riscv
  class Iss

    attr_accessor :memory
    def initialize
      puts "RISCV ISS - Instruction Set Simulator".center(80,'=')
      puts "warning : this ISS only works _without_ optimizations  (-O0 required for gcc)."
      puts "          Mind that -00 does not produce .text.startup section."
      puts "          ISS is based on this assumption."
    end

    def load_program program
      puts "=> loading #{program.name}"
      @program=program
      create_memory
    end

    def create_memory
      puts " - create ISS memory"
      @memory={}
      @symbolic_memory={}
      text_section=@program.get_section ".text"
      text_section.blocks.each do |block|
        puts "    - dealing with block #{block.label}"
        block.instructions.each do |instr|
          addr=instr.address.to_i(16)
          bin =instr.bin.to_i(16)
          @memory[addr]=bin
          @symbolic_memory[addr]=instr
        end
      end
      print_memory
    end

    def print_memory
      puts " - printing memory"
      puts "ISA encoding : "
      ISA::FORMAT_ENCODING_H.each do |type,encoding|
        puts "#{type} : #{encoding}"
      end
      max_hexa_digits=@memory.keys.map{|addr| addr.to_s(16).size}.max
      @memory.each do |addr,bin|
        symbolic_instr=@symbolic_memory[addr]
        instr="#{symbolic_instr.name} #{symbolic_instr.args.join(',')}".ljust(20,'.')
        opcode=bin & 0b1111111 # 7 bits LSB
        unless format=ISA::OPCODE_FORMAT_H[opcode]
          format="?_unknown"
        end
        format_s=format.to_s.split("_").first
        decoding={}
        ISA::FORMAT_ENCODING_H[format].each do |field_name,field_range|
          decoding[field_name]=bitfield(bin,field_range).to_s(16)
        end
        begin
          disassemble_instr=disassemble_hash(decoding)
        rescue Exception => e
          puts e
          puts e.backtrace
          raise
        end
        puts "#{addr.to_s(16).rjust(max_hexa_digits)} #{bin.to_s(16).rjust(8,'0')} #{bin.to_s(2).rjust(32,'0')} #{instr}"
        puts "\t#{decoding}"
        puts "\t#{format_s}"
        puts "\t#{disassemble_instr}"
      end
    end

    def bitfield bin,range
      msb,lsb=range.begin,range.end
      val=0
      for i in lsb..msb
        val+=2**i
      end
      (bin & val) >> lsb
    end

    def disassemble_hash hash
      #pp hash
      text=[]
      case opcode=hash[:opcode].to_i(16)
      when 0b0110111
        #lui
        text << :lui
      when 0b0010111
        text << :auipc
      when 0b1101111
        text << :jal
      when 0b1100111
        text << :jalr
      when 0b1100011 #===== B type ======
        #beq,bne,blt,bge,bltu,bgeu
        case funct3=hash[:funct3].to_i(16)
        when 0b000
          text << :beq
        when 0b001
          text << :bne
        when 0b100
          text << :blt
        when 0b101
          text << :bge
        when 0b110
          text << :bltu
        when 0b111
          text << :bgeu
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b1100011"
        end
      when 0b0000011
        case funct3=hash[:funct3].to_i(16)
        when 0b000
          text << :lb
        when 0b001
          text << :lh
        when 0b010
          text << :lw
        when 0b100
          text << :lbu
        when 0b101
          text << :lhu
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b0100011"
        end
      when 0b0100011
        case funct3=hash[:funct3].to_i(16)
        when 0b000
          text << :sb
        when 0b001
          text << :sh
        when 0b010
          text << :sw
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b0100011"
        end
      when 0b0010011 #=== i_type
        #addi,slti,sltiu,xori,ori,andi,slli,srli
        rs1=hash[:rs1].to_i(16)
        rd =hash[:rd].to_i(16)
        imm=hash[:imm_11_0].to_i(16)
        case funct3=hash[:funct3].to_i(16)
        when 0b000
          text << [:addi,rd,rs1,imm]
        when 0b010
          text << :slti
        when 0b011
          text << :sltiu
        when 0b100
          text << :xori
        when 0b110
          text << :ori
        when 0b111
          text << :andi
        when 0b001
          text << :slli
        when 0b101
          #srli,srai
          case imm_11_5=(hash[:imm_11_0].to_i(16) & 0b1111111) # 7 bits
          when 0b0000000
            text << :srli
          when 0b0100000
            text << :srai
          else
            raise "unknown case for opcode=0b0010011 with func3=0b101"
          end
        else
          raise "unknown funct3 '0b#{funct3.to_s(2)}'"
        end
      when 0b0110011 #r_type
        case funct3=hash[:funct3].to_i(16)
        when 0b000 #add,#sub
          case imm_11_5=hash[:funct7].to_i(16)
          when 0b0000000
            text << :add
          when 0b0100000
            text << :sub
          else
            raise "unknown case for opcode=0b0110011 with func3=0b000"
          end
        when 0b001
          text << :sll
        when 0b010
          text << :slt
        when 0b011
          text << :sltu
        when 0b100
          text << :xor
        when 0b101
          #srl,sra
          case imm_11_5=(hash[:imm_11_0].to_i(16) & 0b1111111) # 7 bits
          when 0b0000000
            text << :srl
          when 0b0100000
            text << :sra
          else
            raise "unknown case for i_type with func3=0b101"
          end
        when 0b110
          text << :or
        when 0b111
          text << :and
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b0100011"
        end
      when 0b0001111
        #fence, fence.i
      when 0b1100111
        #ecall,ebreak
      when 0b1110011
        #csrrw,etc
      when 0b0110011
        #mul etc
        case funct3=hash[:funct3].to_i(16)
        when 0b000
          text << :mul
        when 0b001
          text << :mulh
        when 0b010
          text << :mulhsu
        when 0b011
          text << :mulhu
        when 0b100
          text << :div
        when 0b101
          text << :divu
        when 0b110
          text << :rem
        when 0b111
          text << :remu
        else
          raise "unknown funct3=0b#{funct3.to_s(2)} for opcode=0b0110011"
        end
      else
        puts "unknown opcode '0b#{opcode.to_s(2).rjust(7,'0')}' in #{hash}"
      end
      return "NIY".red if text.empty?
      return text.join(" ").green
    end

    def run
      puts "=> running"
      exec=@program.get_section ".text"
      main=exec.get_block "<main>"
      unless main
        raise "ERROR : <main> label not found."
      else
        puts "main located at : #{main.start_addr}"
      end
    end
  end
end
