class OS
  class File
    class << self
      def open(path, mode = "r")
        self.new(path, mode)
      end
    end

    def initialize(path, mode = "r")
      @file = VFS::File.open(path, mode)
    end

    def each_line(&block)
      while line = @file.gets(235) do
        block.call line
      end
    end

    def puts(*lines)
      lines.each do |line|
        @file.write line
        if @feed == :crlf
          @file.write "\r"
        end
        @file.write "\n"
      end
    end

    def putc(ch)
      case ch.class
      when Integer
        @file.write ch.chr
      when String
        @file.write ch[0]
      else
        @file.write ch.to_i.chr
      end
      ch
    end

    def close
      @file.close
    end
  end
end
