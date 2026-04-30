class LinuxHeadersAT515 < Formula
  desc "Header files of the Linux kernel"
  homepage "https://kernel.org/"
  url "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.204.tar.gz"
  sha256 "f93dbfa3cffca518ae80263a27a61276848847cf7342b3492a5163ecb86080cf"
  license "GPL-2.0-only"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?linux[._-]v?(5\.15(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "1def4620b7774e1ac02b83ba4923d6548786ec9f58dab5bc03fa60bd46efce1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "86c4711eb59d1414957f2c3698fafb0dc9c1946f56ffebcb0fa41bedfde8591c"
  end

  keg_only :versioned_formula

  depends_on :linux

  def install
    system "make", "headers"

    cd "usr/include" do
      Pathname.glob("**/*.h").each do |header|
        (include/header.dirname).install header
      end
    end
  end

  test do
    assert_match "KERNEL_VERSION", (include/"linux/version.h").read
  end
end
