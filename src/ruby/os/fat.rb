class FAT
  def initialize(drive = "0") # "0".."9"
    #unless FAT.f_mount(drive)
    #  raise RuntimeError.new "Mounting FAT volume failed"
    #end
    @prefix = "#{drive}:"
  end

  def dir_new(path)
    FAT::Dir.new("#{@prefix}#{path}")
  end

  def file_new(path)
    FAT::File.new("#{@prefix}#{path}")
  end

  class Dir
  end

  class File
  end
end
