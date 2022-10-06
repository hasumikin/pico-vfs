fat = FAT.new("0")
VFS.mount(fat, "/")
dir = OS::Dir.new("/")
p dir
dir.each do |f|
  puts f
end
dir.close
