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


      def chdir(path)
        # block_given? ? object : 0
        _pwd = pwd
        if block_given?
          VFS.chdir(path)
          result = yield
          VFS.chdir(_pwd)
          result
        else
          VFS.chdir(path)
        end
      end

      def pwd
        VFS.pwd
      end

      def mkdir(path, mode = 0777)
        VFS.mkdir(path, mode)
      end

      def unlink(path)
        VFS.unlink(path)
      end
    end

    def initialize(path)
      @dir = VFS::Dir.open(path)
    end

    def path
      @dir.fullpath
    end

    def close
      @dir.close
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
