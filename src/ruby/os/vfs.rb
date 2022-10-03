class OS
  class VFS
    VOLUMES ||= Array.new

    class << self
      def mount(device, mountpoint)
        mountpoint << "/" unless mountpoint.end_with?("/")
        if _volume_index(mountpoint)
          raise "Mountpoint `#{mountpoint}` already exists"
        end
        unless mountpoint[0] == '/'
          raise "Mountpoint must start with `/`"
        end
        VOLUMES << {mountpoint: mountpoint, device: device}
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
        path = resolve_path(dir)
        OS::ENV["PWD"] = path
      end

      def resolve_path(path)
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
          next if v[:mountpoint] == "/"
          if sanitized_path.start_with?(v[:mountpoint])
            volume = v[:mountpoint]
            break
          end
        end
        volume ||= "/"
        [volume, sanitized_path[volume.length, 100]]
      end

      # private

      def _volume_index(mountpoint)
        VOLUMES.index { |v| v[:mountpoint] == mountpoint }
      end

    end
  end
end
