class OS
  class File
    class << self
      def open(path, mode = "r")
        self.new(path, mode)
      end
    end

    def initialize(path, mode = "r")
      @file = VFS::File.open(path, mode)
      @initial_pos = @file._tell
    end

    def tell
      @file._tell - @initial_pos
    end
    alias pos tell

    # TODO seek(pos, whence = OS::SEEK_SET)
    def seek(pos)
      @file.seek(pos)
    end

    def rewind
      @file.seek(0)
    end

    def each_line(&block)
      while line = @file.gets(235) do
        block.call line
      end
    end

    # TODO: get(limit, chomp: false) when PicoRuby compiler implements kargs
    def gets
      @file.gets(235)
    end

    def read(length = nil, outbuf = "")
      if length && length < 0
        raise ArgumentError.new("negative length #{length} given")
      end
      if length.is_a?(Integer)
        (length / 255).times do
          buff = @file.read(255)
          buff ? (outbuf << buff) : break
        end
        outbuf << buff if buff = @file.read(length % 255)
      elsif length.nil?
        while buff = @file.read(255)
          outbuf << buff
        end
      else
        # ????
      end
      if 0 == outbuf.length
        (length.nil? || length == 0) ? "" : nil
      else
        outbuf
      end
    end

    def write(*args)
      len = 0
      args.each do |arg|
        len += @file.write(arg)
      end
      return len
    end

    def puts(*lines)
      lines.each do |line|
        @file.write line
        if @feed == :crlf
          @file.write "\r"
        end
        @file.write "\n"
      end
      return nil
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
      return ch
    end

    def printf(farmat, *args)
      puts sprintf(farmat, *args)
      return nil
    end

    def close
      @file.close
      return nil
    end
  end
end
