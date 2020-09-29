module Riscv

  class AstNode
  end

  class ElfProgram < AstNode
    attr_accessor :name
    attr_accessor :sections_h
    def initialize name
      @name=name
      @sections_h={}
    end

    def << section
      @sections_h[section.name]=section
    end

    def get_section name
      @sections_h[name]
    end

  end

  class Section < AstNode
    attr_accessor :name
    attr_accessor :blocks
    attr_accessor :funcs
    def initialize
      @blocks=[]
      @funcs=[]
    end

    def get_block label
      @blocks.find{|bloc| bloc.label==label}
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
