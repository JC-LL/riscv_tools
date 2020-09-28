module Riscv

  class AstNode
  end

  class Section < AstNode
    attr_accessor :labelled_blocks
    attr_accessor :funcs
    def initialize
      @labelled_blocks=[]
      @funcs=[]
    end
  end

  class Labelled_block < AstNode
    attr_accessor :start_addr,:label
    attr_accessor :instructions
    def initialize start_addr=nil,label=nil
      @start_addr=start_addr
      @label=label
      @instructions=[]
    end
  end

  class BasicBlock < Labelled_block
  end

  class ControlFlowGraph < AstNode
    attr_accessor :section
    attr_accessor :bbs
    def initialize section
      @section=section
      @bbs=[]
    end
  end

  class Instruction < AstNode
    attr_accessor :address
    attr_accessor :bin
    attr_accessor :name
    attr_accessor :args
    def initialize addr,bin,name,args
      @address,@bin,@name,@args=addr,bin,name,args
    end

    def inspect
      "#{address}: #{bin} #{name} #{args.join(',')}"
    end
  end

end
