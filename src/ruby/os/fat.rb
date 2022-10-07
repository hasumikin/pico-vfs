class FAT
  def initialize(drive = "0") # "0".."9"
    @prefix = "#{drive}:"
  end

  attr_reader :mountpoint

  def mount(mountpoint)
    @mountpoint = mountpoint
    @fatfs = self._mount("#{@prefix}#{mountpoint}")
  end

  def unmount
    self._unmount(@prefix)
    @fatfs = nil
  end

  def dir_new(path)
    FAT::Dir.new("#{@prefix}#{path}")
  end

  def file_new(path, mode)
    FAT::File.new("#{@prefix}#{path}", mode)
  end

  def chdir(path)
    # FatFs where FF_STR_VOLUME_ID == 2 configured
    # calls f_chdrive internally in f_chdir.
    # This is the reason of passing also @prefix
    FAT::Dir.chdir("#{@prefix}#{path}")
  end

  class Dir
  end

  class File
  end
end
