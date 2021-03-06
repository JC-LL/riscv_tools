# your project process may use rkgen for class generation :
# require_relative "ast_riscv_rkgen"

module Riscv

  class AstNode
    def accept(visitor, arg=nil)
       name = self.class.name.split(/::/).last
       visitor.send("visit#{name}".to_sym, self ,arg) # Metaprograming !
    end

    def str
      ppr=PrettyPrinter.new
      self.accept(ppr)
    end
  end

  class Root < AstNode
    attr_accessor :elements
    def initialize elements=[]
      @elements=elements
    end

    def <<(e)
      @elements << e
    end
  end

  class Ident < AstNode
    attr_accessor :token
    def initialize token=nil
      @token=token
    end
  end

  class Expression
  end

  class Binary < Expression
    attr_accessor :lhs,:op,:rhs
    def initialize lhs=nil,op=nil,rhs=nil
      @lhs,@op,@rhs=lhs,op,rhs
    end
  end

end
