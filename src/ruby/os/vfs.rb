class VFS

  VOLUMES = Array.new

  class << self
    def mount(driver, mountpoint)
      mountpoint << "/" unless mountpoint.end_with?("/")
      if _volume_index(mountpoint)
        raise RuntimeError.new "Mountpoint `#{mountpoint}` already exists"
      end
      unless mountpoint[0] == '/'
        raise ArgumentError.new "Mountpoint must start with `/`"
      end
      VOLUMES << { driver: driver, mountpoint: mountpoint }
      if VOLUMES.count == 1
        chdir("/")
      end
    end

    def unmount(mountpoint)
      mountpoint << "/" unless mountpoint.end_with?("/")
      unless index = _volume_index(mountpoint)
        raise "Mountpoint `#{mountpoint}` doesn't exist"
      end
      if OS::ENV["PWD"].start_with?(mountpoint)
        raise "Can't unmount where you are"
      end
      VOLUMES.delete_at index
      if VOLUMES.empty?
        OS::ENV["PWD"] = nil
      end
    end

    def chdir(dir)
      path = sanitize(dir)
      OS::ENV["PWD"] = path
    end

    def sanitize(path)
      dirs = case path
      when "/"
        [""]
      when ""
        return OS::ENV["HOME"]
      else
        path.split("/")
      end
      if dirs[0] != "" # path.start_with?("/")
        # Relative path
        dirs = OS::ENV["PWD"].split("/") + dirs
      end
      sanitized_dirs = []
      dirs.each do |dir|
        next if dir == "." || dir == ""
        if dir == ".."
          sanitized_dirs.pop
        else
          sanitized_dirs << dir
        end
      end
      "/#{sanitized_dirs.join("/")}"
    end

    def split(sanitized_path)
      volume = nil
      VOLUMES.each do |v|
        if sanitized_path.start_with?(v[:mountpoint])
          if volume
            if volume[:mountpoint].length < v[:mountpoint].length
              volume = v
            end
          else
            volume = v
          end
        end
      end
      unless volume
        raise RuntimeError.new("No mounted volume found")
      end
      [volume, sanitized_path[volume[:mountpoint].length, 255]]
    end

    # private

    def _volume_index(mountpoint)
      VOLUMES.index { |v| v[:mountpoint] == mountpoint }
    end

  end

  class Dir
    def initialize(path)
      sanitized_path = VFS.sanitize(path)
      volume, _path = VFS.split(sanitized_path)
      @fullpath = "#{volume[:mountpoint]}#{_path}"
      @driver = volume[:driver]
      @dir = @driver.dir_new(_path)
      #      ^^^^^^^ FAT::Dir#dir_new
    end

    attr_reader :fullpath

    def close
      @dir.close
    end

    def read(path)
      @dir.read
    end

  end

end
