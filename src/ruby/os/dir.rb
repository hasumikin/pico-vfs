class OS
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
  end
end
