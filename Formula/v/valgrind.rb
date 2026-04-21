class Valgrind < Formula
  desc "Dynamic analysis tools (memory, debug, profiling)"
  homepage "https://www.valgrind.org/"
  url "https://sourceware.org/pub/valgrind/valgrind-3.27.0.tar.bz2"
  sha256 "5b5937de8257ee8f51698ea71b9711adce98061aa07daa4a685efc3af9215bef"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://sourceware.org/pub/valgrind/"
    regex(/href=.*?valgrind[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "57fc318a97c43d1bdae43943c9de23c26c5f804983fe29f4d1853802ce4f6646"
    sha256 x86_64_linux: "df7ce68951218b8d2646a402d30b9733626bb67b80255fd207f4903060528498"
  end

  head do
    url "https://sourceware.org/git/valgrind.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :linux

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-only64bit
      --without-mpicc
    ]

    system "./autogen.sh" if build.head?

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage", shell_output("#{bin}/valgrind --help")
  end
end
