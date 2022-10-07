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
        _pwd = pwd
        VFS::Dir.chdir(path)
        if block_given?
          result = yield
          VFS::Dir.chdir(_pwd)
          result
        else
          0
        end
      end

      def pwd
        OS::ENV["PWD"]
      end

      def mkdir(path, mode = 0777)
        VFS::Dir.mkdir(path, mode)
        return 0
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
      @dir.rewind
      self
    end
  end
end
