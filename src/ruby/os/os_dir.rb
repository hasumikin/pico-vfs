class OS

  ENV = {}

  class Dir
    class << self
      def glob(pattern, flags = 0, base: nil, sort: true)
        # block_given? ? nil : [String]
      end

      def exist?(name)
        # bool
      end

      def empty?(path)
        # bool
      end

      def unlink(*files)
        # Integer
      end

      def chdir(path)
        # block_given? ? object : 0
      end

      def pwd
        # String
      end

      def mkdir(path, mode = 0777)
        # 0
      end
    end

    def initialize(path)
      @dir = VFS::Dir.new(path)
    end

    def path
      @dir.fullpath
    end

    def close
      if @dir.close
        @dir = nil
      else
        raise RuntimeError.new "Unhandled error happened @ dir_close"
      end
    end

    def each(&block)
      while true do
        if filename = @dir.read("/")
          block.call(filename)
        else
          break
        end
      end
    end

    def rewind
      @dir.f_rewinddir
      self
    end
  end
end
