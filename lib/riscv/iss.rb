require_relative 'elfdump_parser'

module Riscv
  class Iss

    attr_accessor :memory
    def initialize
      puts "RISCV ISS - Instruction Set Simulator".center(80,'=')
      puts "warning : this ISS only works without optimizations  (O0 required for gcc)."
      puts "          Mind that -00 does not produce .text.startup section."
      puts "          and the <main> is located just after the other sections."
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
      text_section=@program.get_section ".text"
      text_section.blocks.each do |block|
        puts "    - dealing with block #{block.label}"
        block.instructions.each do |instr|
          addr=instr.address.to_i(16)
          bin =instr.bin.to_i(16)
          @memory[addr]=bin
        end
      end
      print_memory
    end

    def print_memory
      puts " - printing memory"
      max_hexa_digits=@memory.keys.map{|addr| addr.to_s(16).size}.max
      @memory.each do |addr,bin|
        puts "#{addr.to_s(16).rjust(max_hexa_digits)} #{bin.to_s(16).rjust(8,'0')} #{bin.to_s(2).rjust(32,'0')}"
      end
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
