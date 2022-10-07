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

    def puts(line)
      @file.puts(line)
    end

    def close
      @file.close
    end
  end
end
