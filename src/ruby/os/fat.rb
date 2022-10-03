class OS
  class FAT
    class FlashROM
    end

BPB_NumFATs = 0x01
BPB_FATSz16 = 1
BPB_FATSz32 = nil
BPB_RootEntCnt = 0x80
BPB_BytsPerSec = 0x1000
BPB_TotSec16 = 0x0100
BPB_TotSec32 = nil
BPB_RsvdSecCnt = 0x01
BPB_SecPerClus = 0x01

    def initialize(driver = nil)
      @drvier = driver || FlashROM.new

      @FATsSectors = (BPB_FATSz16 || BPB_FATSz32) * BPB_NumFATs
      @RootDirSectors = (BPB_RootEntCnt * 32 + BPB_BytsPerSec - 1) / BPB_BytsPerSec
      @DataSectors = (BPB_TotSec16 || BPB_TotSec32) - BPB_RsvdSecCnt - @FATsSectors - @RootDirSectors
      @countofClusters = @DataSectors / BPB_SecPerClus
      @type = if @countofClusters < 4086
                :fat12
              elsif @countofClusters < 65526
                :fat16
              else
                :fat32
              end
    end

    attr_reader :type, :countofClusters

    def f_open
    end

    def f_close
    end

    def f_read
    end

    def f_write
    end

    def f_sync
    end

    def f_lseek
    end

    def f_opendir
    end

    def f_closedir
    end

    def f_readdir
    end

    def f_chdir
    end

    def f_getcwd
    end

    def f_putc
    end

    def f_puts
    end

    def f_gets
    end

    def f_
    end

    def f_
    end

  end
end
