# VFS and FAT for PicoRuby

Target is RP2040 so far

## Usage

### Flash ROM

```ruby
require "vfs"
require "fat"

driver = FAT.new("0") # "0" represents a logical drive
VFS.mount(driver, "/")

dir = Dir.new("/home") #=> Dir
# internally splits path into "/" and "home",
## the former is drive, the latter is pathname in the drive

dir.each do |fname|
  puts fname
end

dif.close
```

### SD card

```ruby
require "spi"
require "vfs"
require "fat"

# https://github.com/HirohitoHigashi/mruby_io_class_study/blob/main/proposal_SPI.md
spi = SPI.new(unit: 1)
fat = FAT.new(spi)
VFS.mount(fat, "/mnt/sd_card")
```

