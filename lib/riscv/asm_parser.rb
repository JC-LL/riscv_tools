module RISCV
  class AsmParser
    def parse filename
      puts "parsing '#{filename}'"
    end
  end
end

if $PROGRAM_NAME==__FILE__
  filename=ARGV.first
  unless filename and File.exist?(filename)
    raise "I need an existing file as input !"
  end
  RISCV::AsmParser.new.parse filename
end
