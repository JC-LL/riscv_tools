module Riscv
  module Utils
    def step
      puts "step : hit a key !"
      $stdin.gets
    end

    def bitfield bin,range
      msb,lsb=range.begin,range.end
      val=(lsb..msb).map{|i| 2**i}.sum
      (bin & val) >> lsb
    end

    def sx bin,size_init=32
      if bin[size_init-1]==1
        abs_val=-bin
        return 2**32-abs_val
      else
        return bin
      end
    end

    def ux bin,size_init=32
      bin
    end

    def showregs reg=nil
      @reg.each do |id,value|
        if reg and reg==id
          puts "x#{id}".rjust(3)+":#{value.to_s(16).rjust(8,'0')}"
        end
      end
    end

    def showmem addr=nil
      if addr
        value=@memory[addr]
        puts "0x#{addr.to_s(16).rjust(8,'0')} 0x#{value.to_s(16).rjust(8,'0')}"
      else
        @memory.each do |addr,value|
          puts "0x#{addr.to_s(16).rjust(8,'0')} 0x#{value.to_s(16).rjust(8,'0')}"
        end
      end
    end
  end
end
