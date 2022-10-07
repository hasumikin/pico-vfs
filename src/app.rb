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
file = File.open("myfile.txt", "w+")
file.puts "Hello!"
file.close
file = File.open("myfile.txt", "r")
lineno = 1
file.each_line do |line|
  puts "#{lineno}: `#{line}`"
  lineno += 1
end
dir.close
