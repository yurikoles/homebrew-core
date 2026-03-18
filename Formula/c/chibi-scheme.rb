class ChibiScheme < Formula
  desc "Small footprint Scheme for use as a C Extension Language"
  homepage "https://github.com/ashinn/chibi-scheme"
  url "https://github.com/ashinn/chibi-scheme/archive/refs/tags/0.12.tar.gz"
  sha256 "b70a1147bc70a0f90df3fb6081bc99808237fd17a9accf9ee7a2cc20d95a4df0"
  license "BSD-3-Clause"
  head "https://github.com/ashinn/chibi-scheme.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:    "51f839c6bfe00f60d7929f8b55aa8ce3de8b3f0b34a82a886ec782f7850e746b"
    sha256 arm64_sequoia:  "91aa4dee44f150abda4aed2001a7ed4a78abc923a0a550ea863b69d79d53998c"
    sha256 arm64_sonoma:   "3aa850015f232c2e5eb9c4622ac5ad7356ebb07ad3562db673cc02eaf15550fa"
    sha256 arm64_ventura:  "9bc3a2cee147f70c2370b3b2de9f081907c8a5e4399f2115eeddd76dc72dcc61"
    sha256 arm64_monterey: "9e59a68ef1ebcabbf717e8b7f87e7b769f0f380ccdb64e46d4385bdccb53aec9"
    sha256 sonoma:         "a406562fbc9f63a108759d19021614d67153b3d2821a4141e8a3d789e9d1b349"
    sha256 ventura:        "a25bba1715b6a6c6005aed9b6e36ee15f61440fe46bd26a2e765060dc764cc13"
    sha256 monterey:       "f82edaec5b649ae9c309a3f26c54444d55a25bf24fdbfb026774c9241a978d78"
    sha256 arm64_linux:    "51315bc7f7e0820bae24c13d724c4a67d5240f7fa0ff60041aa9f8bf742f0760"
    sha256 x86_64_linux:   "395662059e73c41bc156117acff16a06d156e785d8ddd352788fd0b13df9540c"
  end

  def install
    ENV.deparallelize

    # "make" and "make install" must be done separately
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/chibi-scheme -mchibi -e \"(for-each write '(0 1 2 3 4 5 6 7 8 9))\"")
    assert_equal "0123456789", output
  end
end
