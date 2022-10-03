require_relative "os/vfs"
require_relative "os/fat"
require_relative "os/dir"
require_relative "os/file"
require_relative "os/file-utils"

class OS
  ::OS::ENV ||= Hash.new
end
