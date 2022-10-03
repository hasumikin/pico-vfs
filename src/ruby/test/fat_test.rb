require "test_helper"

class VFSTest < Test::Unit::TestCase
  sub_test_case "initialize" do
    setup do
      @fat = OS::FAT.new
    end

    test "FAT12" do
      assert_equal 253, @fat.countofClusters
      assert_equal :fat12, @fat.type
    end
  end
end
