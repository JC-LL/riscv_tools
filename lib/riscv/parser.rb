# coding: utf-8
require_relative 'generic_parser'
require_relative 'ast'
require_relative 'lexer'

module Riscv

  class Parser < GenericParser

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
        tokens=Lexer.new.tokenize(str)
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
      begin
        @tokens=lex(filename)
        puts "......empty file !" if tokens.size==0
        root=Root.new([])
        while @tokens.any?
          case showNext.kind
          when :comment
            root << acceptIt
          when :directive
            root << parse_directive
          when :label
            root << parse_label
          else
            root << parse_instruction
          end
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

    def parse_directive
      tk=expect(:directive)
      case tk.val
      when ".equ"
        expect :ident
        expect :comma
        parse_expression
      else
        raise 'wrong syntax for directive'
      end
    end

    def parse_expression
      case showNext.kind
      when :ident
        acceptIt
      when :string_literal
        acceptIt
      when :decimal_literal
        acceptIt
      when :hexa_literal
        acceptIt
      else
        raise "syntax error : parse_expression line #{showNext.line}"
      end
    end

    def parse_instruction
      case showNext.val
      when "add","sub","xor","or","and","slt","sltu"
        opcode=acceptIt
        rd=expect :ident
        expect :comma
        rs1=expect :ident
        expect :comma
        rs2=expect :ident
      when "addi","xori","ori","andi","lb","lw","lbu","sb","sw"
        opcode=acceptIt
        rd=expect :ident
        expect :comma
        rs1=expect :ident
        expect :comma
        imm=parse_expression
      when "sout", "din" # simulator mnemonic
        opcode=acceptIt
        arg=acceptIt
      when "halt"
        opcode=acceptIt
      else
        raise "ERROR : parse instruction : #{showNext}"
      end
    end

    # ....etc...
  end
end
