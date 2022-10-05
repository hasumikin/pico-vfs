dir = Dir.new("/")
p dir
puts 1
dir.each do |f|
  puts f
end
puts 2
dir.rewind
dir.each do |f|
  puts f
end
puts 3
dir.close
