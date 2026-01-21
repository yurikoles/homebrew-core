class Ddcutil < Formula
  desc "Control monitor settings using DDC/CI and USB"
  homepage "https://www.ddcutil.com"
  url "https://www.ddcutil.com/tarballs/ddcutil-2.2.4.tar.gz"
  sha256 "08ae3c81aeaaa33cf4ebc32a8049428e76ce557874546e381fd65a82560dd195"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.ddcutil.com/releases/"
    regex(/href=.*?ddcutil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_linux:  "e640871079397865e9993b2e2043cd70c5fe189f5704f4aabc6197a9ce174a32"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "93c626c249b79aa27c6e89521ef2ea2334e9ad7f21897068d48d6af6efc44751"
  end

  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "i2c-tools"
  depends_on "jansson"
  depends_on "kmod"
  depends_on "libdrm"
  depends_on "libusb"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrandr"
  depends_on :linux
  depends_on "systemd"

  # fix segfault in xvrpt_vstring() when building on aarch64, see issue, https://github.com/rockowitz/ddcutil/issues/574
  patch do
    url "https://github.com/rockowitz/ddcutil/commit/40518b12c5d7136fc0bbd30aac96b7e79dff5caa.patch?full_index=1"
    sha256 "1e19d3fbab7f55509beb76863daa143c69feda34a38e65780fc5dec6beefdb09"
  end

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "The following tests probe the runtime environment using multiple overlapping methods.",
      shell_output("#{bin}/ddcutil environment")
  end
end
