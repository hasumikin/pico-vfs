class OS
  class File
    class << self
      def exist?(path)
        # bool
      end

      def open(path, mode = "r")
        # block_given? ? Object : File
      end

      def rename(from, to)
        # 0 or raise
      end

      def unlink(*files)
        # Integer
      end

      def size(file)
        # Integer
      end
    end

    def eof?
      # bool
    end

    def close
      # nil
    end

    def closed?
      # bool
    end

    def each_line(rs = $/, chomp: false, &block)
      # self
    end

    def putc(ch)
      # Object
      #  putc "A" # => A
      #  putc 65  # => A
    end

    def puts(*obj)
      # nil
    end
  end
end
