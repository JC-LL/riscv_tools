require 'erb'
require_relative 'parser'
require_relative 'elfdump_parser'
require_relative 'iss'
require_relative 'pretty_printer'
require_relative 'transformer'
require_relative 'code'

module Riscv

  class Compiler

    attr_accessor :options
    attr_accessor :project_name

    def initialize options={}
      @options=options
    end

    def assemble filename
      @asm=Parser.new.parse filename
    end

    def parse_elfdump elf_filename
      basename=File.basename(elf_filename)
      dot_s_filename="#{basename}.s"
      cmd="riscv64-unknown-elf-objdump -d #{elf_filename} --disassembler-options=no-aliases > #{dot_s_filename}"
      system(cmd)
      ast=ElfDumpParser.new(options).parse dot_s_filename
    end

    def simulate elf_filename
      program = parse_elfdump(elf_filename)
      simulator=Iss.new
      simulator.set_options(options)
      simulator.load_program program
      simulator.run
    end

  end
end
