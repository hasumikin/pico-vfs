if RUBY_ENGINE == "mruby/c"
  Dir = OS::Dir
  File = OS::File
end

fat = FAT.new("0")
VFS.mount(fat, "/")

Dir.chdir("/")
Dir.mkdir("test/")
Dir.mkdir("test/aa")
dir = Dir.new(".")
p dir
dir.each do |f|
  puts f
end
file = File.open("test/myfile.txt", "w+")
file.puts "Hello!","World"
file.printf "%d %s", 5, "Ruby"
file.write "%d %s", "Ruby"
file.close
file = File.open("test/myfile.txt", "r")
#lineno = 1
#file.each_line do |line|
#  puts line
#  lineno += 1
#end
#file.rewind
#puts file.gets
#file.seek 3
#puts file.gets
p file.read()
dir.close
