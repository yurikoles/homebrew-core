class Wmbusmeters < Formula
  desc "Read wired or wireless mbus protocol to acquire utility meter readings"
  homepage "https://github.com/wmbusmeters/wmbusmeters"
  url "https://github.com/wmbusmeters/wmbusmeters/archive/refs/tags/2.0.0.tar.gz"
  sha256 "600beb099bc1ac1d4fd7a78dde89bb753b033cfd9de54ed6f25d3fc705c38042"
  license "GPL-3.0-or-later"
  head "https://github.com/wmbusmeters/wmbusmeters.git", branch: "master"

  depends_on "pkgconf" => :build
  depends_on "librtlsdr"
  depends_on "libusb"
  uses_from_macos "libxml2"

  def install
    # TODO: remove on next version bump; fixed upstream in commit e9ef936d6f18f8
    # Prevent configure from running `find /` to locate libxml2 headers
    inreplace "configure", "LIBXML2INC=$(find / -name xpath.h)", "LIBXML2INC="
    system "./configure", *std_configure_args
    system "make", "TAG=#{version}", "BRANCH=", "COMMIT_HASH=", "CHANGES="
    bin.install "build/wmbusmeters"
    bin.install_symlink "wmbusmeters" => "wmbusmetersd"
    man1.install "wmbusmeters.1"
    (etc/"wmbusmeters").mkpath
  end

  service do
    run [opt_bin/"wmbusmeters", "--useconfig=#{etc}/wmbusmeters"]
    keep_alive true
  end

  test do
    telegram = "234433300602010014007a8e0000002f2f0efd3a1147000000008e40fd3a341200000000"
    expected = '"a_counter":4711'
    output = shell_output("#{bin}/wmbusmeters --format=json #{telegram} MyCounter auto 00010206 NOKEY")
    assert_match expected, output
  end
end
