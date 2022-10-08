class OS
  class File
    class << self
      def open(path, mode = "r")
        self.new(path, mode)
      end
    end

    def initialize(path, mode = "r")
      @file = VFS::File.new(path, mode)
    end

    def each_line(&block)
      @file.each_line(block)
    end

    def puts(*lines)
      lines.each do |line|
        @file.puts(line)
      end
    end

    def putc(ch)
      case ch.class
      when Integer
        @file.putc(ch)
      when String
        @file.putc(ch[0].ord)
      else
        @file.putc(ch.to_i)
      end
      ch
    end

    def close
      @file.close
    end
  end
end
