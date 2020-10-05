require_relative 'elfdump_parser'
require_relative 'isa'

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
        disassemble_instr=disassemble_hash(decoding)
        print "#{addr.to_s(16).rjust(max_hexa_digits)} #{bin.to_s(16).rjust(8,'0')} #{bin.to_s(2).rjust(32,'0')} #{instr}"
        puts "#{format_s} #{decoding} #{disassemble_instr}"
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
      case hash[:opcode].to_i(16)
      when 0b0110111
        #lui
      when 0b0010111
        #auipc
      when 0b1101111
        #jal
      when 0b1100111
        #jalr
      when 0b1100011
        #beq,bne,blt,bge,bltu,bgeu
      when 0b0000011
        #lb,lh,lw,lbu,lhu
      when 0b0100011
        #sb,sh,sw
      when 0b0010011
        #addi,,slti,sltiu,xori,ori,andi,slli,srli
      when 0b0110011
        #add,sub,sll,slt,sltu,xor,srl,sra,or,and
      when 0b0001111
        #fence, fence.i
      when 0b1100111
        #ecall,ebreak
      when 0b1110011
        #csrrw,etc
      when 0b0000001
        #mul etc
      else
        puts "unknown opcode in #{hash}"
      end
      return "?"
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
