
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
      puts "parsing #{filename}"
      begin
        @tokens=lex(filename)
        puts "......empty file !" if tokens.size==0
        root=Root.new([])
        while tokens.any?
          root << parse_section
        end
      rescue Exception => e
        unless options[:mute]
          puts e.backtrace
          puts e
        end
        raise
      end
      root
    end

    def parse_section
      section=Section.new
      if tokens.any?
        print "=> seeking next section..."
        until showNext.is_a? :section
          acceptIt
        end
        acceptIt
        section_name=expect(:directive)
        expect :colon
        puts "found #{section_name.val}"
        parse_labelled_blocks
      end
    end

    def parse_labelled_blocks
      while tokens.any? and  showNext.is_a? :addr_label
        parse_labelled_block
      end
    end

    def parse_labelled_block
      puts "=> parse labelled block"
      addr_label=expect(:addr_label).val
      addr_label.delete!(':')
      addr,label=addr_label.split
      block=Labelled_block.new(addr,label)
      while tokens.any? and showNext.is_a? :addr_instr #address
        block.instructions << parse_instruction_line
      end
      return block
    end

    def parse_instruction_line
      print "   - parse instruction : "
      addr_bin=expect(:addr_instr).val
      addr,bin=addr_bin.split(/:\t/)
      instr=parse_instruction(addr,bin)
      puts instr.inspect
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
        arg=acceptIt
        # supplemental info : (?)
        if showNext.is_a? :label
          acceptIt
        elsif showNext.is_a? :parenth
          acceptIt
        end
        return arg
      end
    end

  end
end