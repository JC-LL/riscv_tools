require_relative 'generic_lexer'
require_relative 'generic_parser'

module Riscv
  class ElfDumpLexer < GenericLexer
    def initialize
      super
      keyword :format
      keyword :section

      #............................................................
      token :label             => /\A\<[\.a-zA-Z0-9_\+]+\>/
      token :directive         => /\A\.[a-zA-Z]+\w*(\.[a-zA-Z]+\w*)?/
      token :addr_label        => /[+-]?[0-9a-fA-F]+ \<(.*)\>\:/
      token :addr_instr        => /[+-]?[0-9a-fA-F]+\:\s*[0-9a-fA-F]+/
      token :ident             => /[a-zA-Z]+[a-zA-Zé0-9\-\_]*/
      token :word              => /(0x)?[+-]?[0-9a-fA-F]+/
      token :comma             => /\A\,/
      token :colon             => /\:/
      token :parenth           => /\A\(\w+\)/
      #............................................................
      token :newline           => /[\n]/
      token :space             => /[ \t\r]+/
      token :minus             => /\-/
      #............................................................
      token :comment           => /\#.*/
      token :unknown           => /.* /

    end #def
  end #class
end #module
