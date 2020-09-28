require 'erb'
require_relative 'parser'
require_relative 'elfdump_parser'
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

    def parse_elfdump filename
      ElfDumpParser.new.parse filename
    end

  end
end
