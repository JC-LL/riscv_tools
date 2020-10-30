require_relative 'elfdump_lexer'
require_relative 'elfdump_ast'

module Riscv

  class ElfDumpParser < GenericParser
    attr_accessor :options
    attr_accessor :lexer,:tokens
    attr_accessor :basename,:filename

    def initialize options={}
      @options=options
    end

    def verbose
      @options[:verbose]
    end

    def lex filename
      unless File.exists?(filename)
        raise "ERROR : cannot find file '#{filename}'"
      end
      begin
        str=IO.read(filename).downcase
        str.gsub!(/\u00A0/,' ')
        tokens=ElfDumpLexer.new.tokenize(str)
        tokens=tokens.select{|t| t.class==Token} # filters [nil,nil,nil]
        tokens.reject!{|tok| tok.is_a? [:comment,:newline,:space]}
        return tokens
      rescue Exception=>e
        unless options[:mute]
          puts e.backtrace
          puts e
        end
        raise "an error occured during LEXICAL analysis. Sorry. Aborting."
      end
    end

    def parse filename
      puts "parsing #{filename}" if verbose
      basename=File.basename(filename)
      begin
        @tokens=lex(filename)
        puts "......empty file !" if tokens.size==0
        elf_program=ElfProgram.new(basename)
        while tokens.any?
          section=parse_section
          elf_program.sections_h[section.name]=section
        end
      rescue Exception => e
        unless options[:mute]
          puts e
          puts e.backtrace
        end
        raise
      end
      elf_program
    end

    def parse_section
      section=Section.new()
      if tokens.any?
        print "=> seeking next section..." if verbose
        until showNext.is_a? :section
          acceptIt
        end
        acceptIt
        section.name=expect(:directive).val
        expect :colon
        puts "found #{section.name}" if verbose
        section.blocks=parse_labelled_blocks
        return section
      end
      nil
    end

    def parse_labelled_blocks
      blocks=[]
      while tokens.any? and  showNext.is_a? :addr_label
        blocks << parse_labelled_block
      end
      blocks
    end

    def parse_labelled_block
      addr_label=expect(:addr_label).val
      addr_label.delete!(':')
      addr,label=addr_label.split
      puts "=> parse labelled block #{label} at #{addr}"  if verbose
      block=Labelled_block.new(addr,label)
      while tokens.any? and showNext.is_a? :addr_instr #address
        block.instructions << parse_instruction_line
      end
      return block
    end

    def parse_instruction_line
      print "   - parse instruction : "  if verbose
      addr_bin=expect(:addr_instr).val
      addr,bin=addr_bin.split(/:\t/)
      instr=parse_instruction(addr,bin)
      puts instr.inspect if verbose
      instr
    end

    def parse_instruction addr,bin
      if showNext.is_a? :ident
        mnemo=acceptIt.val.to_sym
      else
        raise "expecting an instruction mnemonic. Got '#{showNext}'"
      end
      args=parse_args
      Instruction.new(addr,bin,mnemo,args)
    end

    def parse_args
      args=[]
      args << parse_arg
      while tokens.any? and showNext.is_a? :comma
        acceptIt
        args << parse_arg
      end
      args
    end

    def parse_arg
      if showNext.is_a? [:word,:ident]
        arg=Arg.new(acceptIt)
        # supplemental info : (?)
        if showNext.is_a? :label
          acceptIt
        elsif showNext.is_a? :parenth
          arg=ArgParenth.new(arg.tok,acceptIt)
        end
        return arg
      end
    end

  end
end
