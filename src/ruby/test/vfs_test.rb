require "test_helper"

class VFSTest < Test::Unit::TestCase
  sub_test_case "chdir" do
    setup do
      OS::VFS::VOLUMES.clear
      OS::VFS::VOLUMES << {mountpoint: "/bin", device: nil}
      OS::ENV['PWD'] = "/home"
    end

    test "chdir 1" do
      OS::VFS.chdir("abc")
      assert_equal "/home/abc", OS::ENV["PWD"]
    end

    test "chdir 2" do
      OS::VFS.chdir("../abc")
      assert_equal "/abc", OS::ENV["PWD"]
    end
  end

  sub_test_case "mount" do
    setup do
      OS::VFS::VOLUMES.clear
      OS::VFS::VOLUMES << {mountpoint: "/", device: nil}
    end

    test "able to mount" do
      device = nil
      OS::VFS.mount(device, "/dev")
      assert_equal [
        {mountpoint: "/", device: nil},
        {mountpoint: "/dev/", device: device}
      ], OS::VFS::VOLUMES
    end

    test "unable to mount" do
      device = nil
      assert_raise "Mountpoint `/` already exists" do
        OS::VFS.mount(device, "/")
      end
    end
  end

  sub_test_case "unmount" do
    setup do
      OS::VFS::VOLUMES.clear
      OS::VFS::VOLUMES << {mountpoint: "/", device: nil}
      OS::VFS::VOLUMES << {mountpoint: "/dev/", device: nil}
    end

    test "able to unmount" do
      device = nil
      OS::VFS.unmount("/dev")
      assert_equal [{mountpoint: "/", device: device}], OS::VFS::VOLUMES
    end

    test "unable to unmount" do
      device = nil
      assert_raise "Can't unmount where you are" do
        OS::VFS.unmount("/")
      end
    end
  end

  sub_test_case "split" do
    setup do
      OS::VFS::VOLUMES.clear
      OS::VFS::VOLUMES << {mountpoint: "/", device: nil}
      OS::VFS::VOLUMES << {mountpoint: "/dev/", device: nil}
    end

    test "exists cases" do
      assert_equal OS::VFS.split("/home"), ["/", "home"]
      assert_equal OS::VFS.split("/dev/pty"), ["/dev/", "pty"]
    end
  end

  sub_test_case "resolve_path" do
    setup do
      OS::ENV["PWD"] = "/home"
      OS::ENV["HOME"] = "/home/my_home"
    end

    test "blank case" do
      assert_equal OS::VFS.resolve_path(""), "/home/my_home"
    end

    test "simple cases" do
      assert_equal OS::VFS.resolve_path("abc"), "/home/abc"
      assert_equal OS::VFS.resolve_path("abc/cde"), "/home/abc/cde"
      assert_equal OS::VFS.resolve_path("abc/cde"), "/home/abc/cde"
    end

    test "../ cases" do
      assert_equal OS::VFS.resolve_path("../abc"), "/abc"
      assert_equal OS::VFS.resolve_path("../../abc"), "/abc"
      assert_equal OS::VFS.resolve_path("../home/abc"), "/home/abc"
      assert_equal OS::VFS.resolve_path("abc/../abc"), "/home/abc"
    end

    test "./ cases" do
      assert_equal OS::VFS.resolve_path("./abc"), "/home/abc"
      assert_equal OS::VFS.resolve_path("././abc"), "/home/abc"
    end

    test "starts with / cases" do
      assert_equal OS::VFS.resolve_path("/"), "/"
      assert_equal OS::VFS.resolve_path("/dev"), "/dev"
      assert_equal OS::VFS.resolve_path("/home/abc/xyz/.."), "/home/abc"
    end

    test "ends with / cases" do
      assert_equal OS::VFS.resolve_path("abc/"), "/home/abc"
      assert_equal OS::VFS.resolve_path("../home/abc/"), "/home/abc"
      assert_equal OS::VFS.resolve_path("/home/abc/xyz/../"), "/home/abc"
    end
  end
end
