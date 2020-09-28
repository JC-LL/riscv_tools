require_relative 'generic_lexer'
require_relative 'generic_parser'

module Riscv
  class Lexer < GenericLexer
    def initialize
      super
      #.............................................................
      token :comment           => /\A\#(.*)$/
      token :label             => /\A[a-zA-Z0-9_]+\:/
      token :directive         => /\.[a-zA]\w+/

      token :ident             => /\A[a-zA-Z]\w*/
      token :string_literal    => /\A"[^"]*"/
      token :letter_literal    => /\A'[^']*'/
      token :decimal_literal   => /[+-]?\d+/
      token :hexa_literal      => /0x[0-9a-fA-F]+/
      token :comma             => /\A\,/
      #............................................................
      token :newline           =>  /[\n]/
      token :space             => /[ \t\r]+/

    end #def
  end #class
end #module
