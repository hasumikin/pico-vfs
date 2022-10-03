# VFS and FAT for PicoRuby

Target is RP2040 so far

## Usage

### Flash ROM

```ruby
require "vfs"
require "fat"

fat = FAT.new() # to use flash
VFS.mount(fat, "/")
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

