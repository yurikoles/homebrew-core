class Feh < Formula
  desc "X11 image viewer"
  homepage "https://feh.finalrewind.org/"
  url "https://feh.finalrewind.org/feh-3.12.1.tar.bz2"
  sha256 "6772f48e7956a16736e4c165a8367f357efc413b895f5b04133366e01438f95d"
  license "MIT-feh"

  livecheck do
    url :homepage
    regex(/href=.*?feh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "acd6946f531bbe923078fbb4d0dd3ca298bb074bd78ab853e9adf4c69087b6e7"
    sha256 arm64_sequoia: "823cac9c826de44b2413df78d3399cf781525b5189bc6d55003097c20607b087"
    sha256 arm64_sonoma:  "bbbfdbe90db4b0354f51cc90e046495876fce6e3122a792ddd4e09a4be3a67e4"
    sha256 sonoma:        "03ff660534bc9a35c309f0755bd263d805e68e6a93f15016bdf4136761cdf0c3"
    sha256 arm64_linux:   "7e494188e34225311fb3ae5e9ba167a1d2ae1600a90d9eda680677097577b42b"
    sha256 x86_64_linux:  "3c91917785f8097674d4a6dc658b16d7305e2ff8b9a09e77c84a70436030a6cf"
  end

  depends_on "imlib2"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "libx11"
  depends_on "libxinerama"
  depends_on "libxt"

  uses_from_macos "curl"

  def install
    system "make", "PREFIX=#{prefix}", "verscmp=0", "exif=1"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/feh -v")
  end
end
